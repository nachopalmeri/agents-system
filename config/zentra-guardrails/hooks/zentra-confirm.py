#!/usr/bin/env python3
"""Hooks de Zentra (Claude Code WSL, cuenta de trabajo).
PreToolUse  -> "ask" (confirmación explícita) antes de:
   * skill zentra-deploy, /hotfix, /rollback-epic (tool Skill o SlashCommand)
   * Bash que deploya/publica/modifica Tiendanube (tn:deploy, tn-deploy.js, zentra-deploy.mjs,
     tn:mark-deploy/prune/variants/disable-coupons/split/preventa/gallery, POST/PUT/DELETE a api.tiendanube)
   * FTP / subida de theme (lftp, sftp, ftp://, curl -T, put/mirror -R de templates)
   * producción en general (--target=prod, :prod, wrangler deploy, vercel --prod, supabase db push/functions deploy, npm publish)
   * git push a main/master (o --all/--mirror) y gh pr merge en repos de leotocca
PreToolUse  -> "deny": correr OpenCode (DeepSeek / modelos gratis) dentro de un repo de leotocca/Zentra
               hasta que Leo lo apruebe.
UserPromptSubmit -> si el prompt arranca con /hotfix, /zentra-deploy o /rollback-epic, agrega un
               recordatorio de pedir confirmación antes de cada paso que toque la tienda.
Instalado por Dev Radar 14/11/2026. Rollback: ~/.claude/ROLLBACK-guardrails-20261114.txt
"""
import json, os, re, subprocess, sys

ZENTRA_DIRS = [os.path.expanduser("~/projects/zentra")]
I = re.I
SKILL_RX = re.compile(r"(^|[:/])(zentra-deploy|hotfix|rollback-epic)\b", I)
DRY_RX = re.compile(r"(--dry-run\b|:dry\b|\s--dry\b)", I)
BASH_ASK = [
    (re.compile(r"zentra-deploy(\.mjs)?\b", I), "deploy de Zentra (zentra-deploy)", True),
    (re.compile(r"(\btn[:-]deploy\b|tn-deploy\.js)", I), "deploy a Tiendanube (tn:deploy)", True),
    (re.compile(r"\btn[:-](mark-deploy|prune|disable-coupons|split-product|preventa[\w-]*|gallery)\b|scripts/tn-(mark-deploy|prune|disable-coupons|split-product|update-[\w-]+|gallery)", I), "script que modifica la tienda Tiendanube", True),
    (re.compile(r"\btn:variants\b(?!:list)|tn-manage-variants\.js(?!\s+list\b)", I), "script que modifica variantes en Tiendanube", True),
    (re.compile(r"(api\.tiendanube\.com|api\.nuvemshop\.com\.br|tiendanube\.com/v1)[^;&|]*(-x\s*(post|put|patch|delete)|--request\s*(post|put|patch|delete)|\s-d\s|--data|\s-f\s|--form|\s-t\s)|(-x\s*(post|put|patch|delete)|--request\s*(post|put|patch|delete)|\s-d\s|--data)[^;&|]*(api\.tiendanube\.com|api\.nuvemshop)", I), "escritura en la API de Tiendanube", False),
    (re.compile(r"(^|[\s;&|(])(lftp|sftp|ftp|ncftp\w*|wput|curlftpfs|winscp(\.com)?)(\s|$)|\b(s?ftps?)://|--ftp-|\bcurl\b[^;&|]*\s(-t|--upload-file)\s", I), "FTP / subida de archivos (theme)", False),
    (re.compile(r"\b(put|mput|mirror\s+-r|upload|push|publish)\b[^;&|]*\b(theme|brasilia|layouts?/|templates?/|snipplets?/|static/)", I), "subida de theme de Tiendanube", False),
    (re.compile(r"\b(nube-?cli|tiendanube-cli|tn-cli)\b", I), "CLI de Tiendanube", False),
    (re.compile(r"--target[= ]prod\b|\b(deploy|publish|release|push)[\w:-]*:prod\b", I), "deploy a producción", True),
    (re.compile(r"\bwrangler\s+(deploy|publish|pages\s+deploy|secret\s+put|versions\s+deploy)", I), "deploy a Cloudflare (producción)", False),
    (re.compile(r"\bvercel\b[^;&|]*(--prod\b|\bpromote\b)", I), "deploy a producción en Vercel", False),
    (re.compile(r"\bsupabase\s+(db\s+push|functions\s+deploy|secrets\s+set|migration\s+up)", I), "cambio en Supabase (producción)", False),
    (re.compile(r"\b(npm|pnpm|yarn)\s+publish\b", I), "publicación de paquete", False),
]
GIT_PUSH_RX = re.compile(r"\bgit\b(?P<pre>[^;&|]*?)\bpush\b(?P<args>[^;&|]*)", I)
GH_MERGE_RX = re.compile(r"\bgh\s+pr\s+merge\b", I)
OPENCODE_RX = re.compile(r"(^|[\s;&|(/])opencode(\.exe)?(\s|$)", I)


def ask(reason):
    return {"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask",
            "permissionDecisionReason": "Zentra: " + reason + ". Confirmá explícitamente antes de seguir (revisá destino DEV/PROD y que haya backup)."}}


def deny(reason):
    return {"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny",
            "permissionDecisionReason": reason}}


def git(dirpath, *args):
    try:
        r = subprocess.run(["git", "-C", dirpath, *args], capture_output=True, text=True, timeout=3)
        return r.stdout.strip() if r.returncode == 0 else ""
    except Exception:
        return ""


def target_dir(cmd, cwd):
    m = re.search(r"\bgit\s+-C\s+(\"[^\"]+\"|'[^']+'|\S+)", cmd)
    if m:
        d = m.group(1).strip("'\"")
    else:
        m = re.search(r"\bcd\s+(\"[^\"]+\"|'[^']+'|[^\s;&|]+)", cmd)
        d = m.group(1).strip("'\"") if m else cwd
    d = os.path.expanduser(d)
    if not os.path.isabs(d):
        d = os.path.join(cwd or os.getcwd(), d)
    return d


def is_zentra_dir(d):
    d = os.path.realpath(os.path.expanduser(d or ""))
    for z in ZENTRA_DIRS:
        if d == z or d.startswith(z + os.sep):
            return True
    return "leotocca" in git(d, "remote", "-v").lower() if os.path.isdir(d) else False


def check_push(cmd, cwd):
    m = GIT_PUSH_RX.search(cmd)
    if not m:
        return None
    d = target_dir(cmd, cwd)
    if not is_zentra_dir(d):
        return None
    args = m.group("args")
    if re.search(r"--all\b|--mirror\b", args):
        return "git push --all/--mirror en un repo de leotocca"
    if re.search(r"(^|[\s:+])(main|master)(\s|$)", args):
        return "git push a main/master en un repo de leotocca"
    refs = [a for a in args.split() if not a.startswith("-")]
    if len(refs) <= 1:
        branch = git(d, "branch", "--show-current")
        if branch in ("main", "master"):
            return "git push desde main/master en un repo de leotocca"
    return None


def pre_tool(ev):
    tool = ev.get("tool_name", "")
    ti = ev.get("tool_input") or {}
    cwd = ev.get("cwd") or os.getcwd()
    if tool in ("Skill", "SlashCommand"):
        name = str(ti.get("skill") or ti.get("command") or ti.get("name") or "").strip()
        first = name.split()[0] if name else ""
        if SKILL_RX.search(first):
            return ask(f"vas a correr {first} (deploy/hotfix/rollback de la tienda)")
        return None
    if tool != "Bash":
        return None
    cmd = str(ti.get("command", ""))
    if OPENCODE_RX.search(cmd) and (is_zentra_dir(cwd) or re.search(r"projects/zentra\b|leotocca", cmd, I)):
        return deny("Zentra: OpenCode (DeepSeek / modelos gratis) no se usa en repos de leotocca hasta que Leo lo apruebe. "
                    "Hacelo con Claude Code y la cuenta de Zentra.")
    for rx, reason, dry_ok in BASH_ASK:
        if rx.search(cmd):
            if dry_ok and DRY_RX.search(cmd):
                continue
            return ask(reason)
    r = check_push(cmd, cwd)
    if r:
        return ask(r)
    if GH_MERGE_RX.search(cmd) and is_zentra_dir(target_dir(cmd, cwd)):
        return ask("gh pr merge en un repo de leotocca (merge a main)")
    return None


def prompt_submit(ev):
    p = str(ev.get("prompt", "")).lstrip()
    if re.match(r"/(zentra:)?(hotfix|zentra-deploy|rollback-epic)\b", p, I):
        return {"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext":
                "Regla de Nacho: este comando toca la tienda Zentra. Antes de cada deploy, push a main, FTP o escritura en "
                "Tiendanube, mostrá el destino (DEV/PROD), el diff y el backup, y esperá un 'sí' explícito. Por defecto, DEV."}}
    return None


def main():
    try:
        ev = json.loads(sys.stdin.read() or "{}")
    except Exception:
        print("{}")
        return 0
    event = ev.get("hook_event_name") or (sys.argv[1] if len(sys.argv) > 1 else "PreToolUse")
    out = prompt_submit(ev) if event == "UserPromptSubmit" else pre_tool(ev)
    print(json.dumps(out or {}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
