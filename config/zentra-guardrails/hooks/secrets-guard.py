#!/usr/bin/env python3
"""PreToolUse (Claude Code): niega leer secretos (.env*, *.pem, *.key, credenciales,
~/.config/secrets, ~/.aws, ~/.ssh, keys de Tiendanube/Supabase/Cloudflare...).
Cubre Read, Grep, Glob, NotebookRead y Bash (cat/head/grep/source/cp/... y echo $TOKEN).
Reglas: secret-rules.json al lado de este archivo. Salida: JSON permissionDecision=deny.
Instalado por Dev Radar 14/11/2026. Rollback: ~/.claude/ROLLBACK-guardrails-20261114.txt
"""
import json, os, re, shlex, sys

HERE = os.path.dirname(os.path.abspath(__file__))
RULES = json.load(open(os.path.join(HERE, "secret-rules.json"), encoding="utf-8"))
PATS = [re.compile(p) for p in RULES["path_patterns"]]
SAFE = set(RULES["safe_bash_verbs"])
ENVNAME = RULES["env_var_name"]
ENV_PRINT = re.compile(r"\b(echo|printf|print|printenv|declare\s+-p|typeset\s+-p|write-output|write-host)\b[^|;&\n]*?\$(\{)?(env:)?" + ENVNAME, re.I)
PRINTENV_NAME = re.compile(r"\bprintenv\s+" + ENVNAME, re.I)
ENV_DUMP = re.compile(r"(^|[;&|]\s*|\$\(\s*)(env|printenv|export\s+-p|set|get-childitem\s+env:|gci\s+env:|dir\s+env:|ls\s+env:)\s*($|[|;&>)])", re.I)
REASON = ("Bloqueado por secrets-guard: no se leen archivos ni variables con secretos ({what}). "
          "Si necesitás el valor, cargalo vos a mano o usá un .env.example; nunca lo pegues en el chat.")


def norm(p):
    p = str(p or "").strip().strip("'\"`").replace("\\", "/").lower()
    p = re.sub(r"/+", "/", p) if not p.startswith("//") else "//" + re.sub(r"/+", "/", p[2:])
    return p.rstrip("/") if len(p) > 1 else p


def secret_path(p):
    n = norm(p)
    if not n:
        return None
    for rx in PATS:
        if rx.search(n):
            return n
    return None


def glob_secret(pattern):
    n = norm(pattern)
    if re.search(r"(^|/)\.env", n):
        return n
    return secret_path(n.replace("**", "x").replace("*", "x").replace("?", "x"))


def tokens(cmd):
    try:
        lex = shlex.shlex(cmd, posix=True, punctuation_chars=";&|<>()")
        lex.whitespace_split = True
        toks = list(lex)
    except ValueError:
        toks = re.split(r"[\s;&|<>()'\"`]+", cmd)
    out = []
    for t in toks:
        for part in re.split(r"[=:,](?=[~./a-z\\])", t, flags=re.I) if "=" in t or "," in t else [t]:
            out.append(part)
        out.append(t)
    out.extend(re.findall(r"[\w~.$/\\:-]+", cmd))
    return out


def segments(cmd):
    return [s.strip() for s in re.split(r"\|\||&&|[;|&\n]", cmd) if s.strip()]


def first_verb(seg):
    words = seg.split()
    while words and (re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", words[0]) or words[0] in ("sudo", "command", "builtin", "time", "nohup", "env")):
        words = words[1:]
    return os.path.basename(words[0].lower()) if words else ""


def check_bash(cmd):
    if ENV_PRINT.search(cmd) or PRINTENV_NAME.search(cmd):
        return "variable de entorno con token/key"
    if ENV_DUMP.search(cmd):
        return "volcado completo del entorno (env/printenv/set)"
    for seg in segments(cmd):
        hit = None
        for t in tokens(seg):
            if secret_path(t):
                hit = norm(t)
                break
        if hit and first_verb(seg) not in SAFE:
            return hit
    return None


def decide(ev):
    tool = ev.get("tool_name", "")
    ti = ev.get("tool_input") or {}
    if tool in ("Read", "NotebookRead", "Edit", "MultiEdit", "NotebookEdit"):
        hit = secret_path(ti.get("file_path") or ti.get("notebook_path") or ti.get("path"))
        if hit:
            return hit
    elif tool == "Grep":
        for k in ("path",):
            hit = secret_path(ti.get(k))
            if hit:
                return hit
        if ti.get("glob") and glob_secret(ti["glob"]):
            return norm(ti["glob"])
    elif tool == "Glob":
        if glob_secret(ti.get("pattern", "")):
            return norm(ti.get("pattern"))
        hit = secret_path(ti.get("path"))
        if hit:
            return hit
    elif tool in ("Bash", "PowerShell"):
        return check_bash(str(ti.get("command", "")))
    return None


def main():
    try:
        ev = json.loads(sys.stdin.read() or "{}")
    except Exception:
        print("{}")
        return 0
    what = decide(ev)
    if what:
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": REASON.format(what=what[:120])}}, ensure_ascii=False))
    else:
        print("{}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
