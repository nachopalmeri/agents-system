#!/usr/bin/env python3
"""Tests de secrets-guard.py y zentra-confirm.py: simulan el JSON de entrada de Claude Code.
Uso: python3 ~/.claude/hooks/test_hooks.py            (WSL: los dos hooks)
     python  C:/Users/Nacho/.claude/hooks/test_hooks.py --only-secrets   (Windows)
"""
import json, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
PY = sys.executable
fails = 0; total = 0


def run(script, ev):
    r = subprocess.run([PY, os.path.join(HERE, script)], input=json.dumps(ev), capture_output=True, text=True, timeout=20)
    out = json.loads(r.stdout or "{}")
    hso = out.get("hookSpecificOutput", {})
    return hso.get("permissionDecision") or ("context" if hso.get("additionalContext") else None)


def case(script, name, ev, expect):
    global fails, total
    total += 1
    got = run(script, ev)
    ok = got == expect
    fails += 0 if ok else 1
    print(("PASS " if ok else "FAIL ") + f"[{script.split('.')[0]}] {name}: esperado={expect} obtenido={got}")


def T(tool, **ti):
    return {"hook_event_name": "PreToolUse", "tool_name": tool, "tool_input": ti, "cwd": os.path.expanduser("~")}


S = "secrets-guard.py"
home = os.path.expanduser("~")
secret_cases = [
    ("Read .env", T("Read", file_path="/repo/.env"), "deny"),
    ("Read .env.local", T("Read", file_path="/repo/.env.local"), "deny"),
    ("Read .env.example (permitido)", T("Read", file_path="/repo/.env.example"), None),
    ("Read deepseek.env en ~/.config/secrets", T("Read", file_path=home + "/.config/secrets/deepseek.env"), "deny"),
    ("Read README de ~/.config/secrets", T("Read", file_path=home + "/.config/secrets/README.txt"), "deny"),
    ("Read ~/.aws/credentials", T("Read", file_path="~/.aws/credentials"), "deny"),
    ("Read clave .pem", T("Read", file_path="C:\\Users\\Nacho\\certs\\server.pem"), "deny"),
    ("Read .key", T("Read", file_path="/x/tls/private.key"), "deny"),
    ("Read id_ed25519", T("Read", file_path="~/.ssh/id_ed25519"), "deny"),
    ("Read id_ed25519.pub (permitido)", T("Read", file_path="~/.ssh/id_ed25519.pub"), None),
    ("Read .credentials.json de Claude", T("Read", file_path=home + "/.claude/.credentials.json"), "deny"),
    ("Read .dev.vars (Cloudflare)", T("Read", file_path="/repo/worker/.dev.vars"), "deny"),
    ("Read wrangler config", T("Read", file_path=home + "/.config/.wrangler/config/default.toml"), "deny"),
    ("Read token de Supabase CLI", T("Read", file_path=home + "/.supabase/access-token"), "deny"),
    ("Read tiendanube-token.json", T("Read", file_path="/repo/scripts/tiendanube-token.json"), "deny"),
    ("Read supabase-service-role.txt", T("Read", file_path="/repo/supabase-service-role.txt"), "deny"),
    ("Read auth.json de opencode", T("Read", file_path="C:/Users/Nacho/.local/share/opencode/auth.json"), "deny"),
    ("Read archivo normal", T("Read", file_path="/repo/src/index.ts"), None),
    ("Read SKILL de token-efficiency (no es secreto)", T("Read", file_path=home + "/.agents/skills/token-efficiency-check/SKILL.md"), None),
    ("Read environment.ts (no es secreto)", T("Read", file_path="/repo/src/environment.ts"), None),
    ("Grep con path .env", T("Grep", pattern="KEY", path="/repo/.env"), "deny"),
    ("Grep con glob .env*", T("Grep", pattern="TN_", glob="**/.env*"), "deny"),
    ("Grep en ~/.config/secrets", T("Grep", pattern="sk-", path="~/.config/secrets"), "deny"),
    ("Grep normal", T("Grep", pattern="fetchpriority", path="/repo/src"), None),
    ("Glob **/.env*", T("Glob", pattern="**/.env*"), "deny"),
    ("Glob **/*.pem", T("Glob", pattern="**/*.pem"), "deny"),
    ("Glob **/*.astro", T("Glob", pattern="**/*.astro"), None),
    ("Bash cat .env", T("Bash", command="cat .env"), "deny"),
    ("Bash head -5 apps/web/.env.production", T("Bash", command="head -5 apps/web/.env.production"), "deny"),
    ("Bash cat .env.example (permitido)", T("Bash", command="cat .env.example"), None),
    ("Bash grep en .env", T("Bash", command="grep TIENDANUBE .env | cut -d= -f2"), "deny"),
    ("Bash source .env", T("Bash", command="source .env && npm run dev"), "deny"),
    ("Bash cat deepseek.env", T("Bash", command="cat ~/.config/secrets/deepseek.env"), "deny"),
    ("Bash ls ~/.config/secrets (solo nombres)", T("Bash", command="ls -la ~/.config/secrets"), None),
    ("Bash cp .env", T("Bash", command="cp .env /tmp/x"), "deny"),
    ("Bash python lee .env", T("Bash", command="python3 -c \"print(open('.env').read())\""), "deny"),
    ("Bash --env-file=.env", T("Bash", command="node --env-file=.env scripts/x.js"), "deny"),
    ("Bash echo $TIENDANUBE_ACCESS_TOKEN", T("Bash", command="echo $TIENDANUBE_ACCESS_TOKEN"), "deny"),
    ("Bash printenv SUPABASE_SERVICE_ROLE_KEY", T("Bash", command="printenv SUPABASE_SERVICE_ROLE_KEY"), "deny"),
    ("Bash echo ${CLOUDFLARE_API_TOKEN}", T("Bash", command="echo \"${CLOUDFLARE_API_TOKEN}\""), "deny"),
    ("Bash env | grep", T("Bash", command="env | grep -i token"), "deny"),
    ("Bash printenv solo", T("Bash", command="printenv"), "deny"),
    ("Bash curl usando $TOKEN sin imprimir (permitido)", T("Bash", command="curl -s -H \"Authentication: bearer $TN_ACCESS_TOKEN\" https://api.tiendanube.com/v1/1/products"), None),
    ("Bash echo $HOME (permitido)", T("Bash", command="echo $HOME"), None),
    ("Bash cat ~/.aws/credentials", T("Bash", command="cat ~/.aws/credentials"), "deny"),
    ("Bash type C:\\secrets\\.env (Windows)", T("Bash", command="type C:\\app\\.env"), "deny"),
    ("Bash normal", T("Bash", command="npm run build && git status"), None),
    ("Bash set -e (permitido)", T("Bash", command="set -euo pipefail; npm test"), None),
    ("Edit no aplica a archivos normales", T("Edit", file_path="/repo/a.ts", old_string="a", new_string="b"), None),
]

for n, ev, exp in secret_cases:
    case(S, n, ev, exp)

if "--only-secrets" not in sys.argv:
    Z = "zentra-confirm.py"
    zdir = os.path.expanduser("~/projects/zentra")
    tmp = tempfile.mkdtemp(prefix="zg-test-")
    subprocess.run(["git", "init", "-q", "-b", "main", tmp], check=True)
    subprocess.run(["git", "-C", tmp, "remote", "add", "origin", "https://github.com/leotocca/fake-test.git"], check=True)
    mine = tempfile.mkdtemp(prefix="zg-mine-")
    subprocess.run(["git", "init", "-q", "-b", "main", mine], check=True)
    subprocess.run(["git", "-C", mine, "remote", "add", "origin", "https://github.com/nachopalmeri/x.git"], check=True)

    def B(cmd, cwd=zdir):
        return {"hook_event_name": "PreToolUse", "tool_name": "Bash", "tool_input": {"command": cmd}, "cwd": cwd}

    zcases = [
        ("Skill zentra:zentra-deploy", {"hook_event_name": "PreToolUse", "tool_name": "Skill", "tool_input": {"skill": "zentra:zentra-deploy"}}, "ask"),
        ("Skill zentra-deploy", {"hook_event_name": "PreToolUse", "tool_name": "Skill", "tool_input": {"skill": "zentra-deploy", "args": "--target=prod"}}, "ask"),
        ("Skill zentra:hotfix", {"hook_event_name": "PreToolUse", "tool_name": "Skill", "tool_input": {"skill": "zentra:hotfix"}}, "ask"),
        ("SlashCommand /hotfix", {"hook_event_name": "PreToolUse", "tool_name": "SlashCommand", "tool_input": {"command": "/hotfix arreglar precio"}}, "ask"),
        ("SlashCommand /rollback-epic", {"hook_event_name": "PreToolUse", "tool_name": "SlashCommand", "tool_input": {"command": "/zentra:rollback-epic 12"}}, "ask"),
        ("Skill tdd (no)", {"hook_event_name": "PreToolUse", "tool_name": "Skill", "tool_input": {"skill": "zentra:tdd"}}, None),
        ("npm run tn:deploy", B("npm run tn:deploy"), "ask"),
        ("npm run tn:deploy:prod", B("npm run tn:deploy:prod"), "ask"),
        ("npm run tn:deploy:dev", B("npm run tn:deploy:dev"), "ask"),
        ("npm run tn:deploy:dev:dry (permitido)", B("npm run tn:deploy:dev:dry"), None),
        ("node scripts/tn-deploy.js --target=prod", B("node scripts/tn-deploy.js --target=prod"), "ask"),
        ("node zentra-deploy.mjs", B("node /home/nacho/.claude/plugins/cache/claude-zentra/zentra/x/skills/zentra-deploy/scripts/zentra-deploy.mjs --target=prod --force"), "ask"),
        ("npm run tn:mark-deploy", B("npm run tn:mark-deploy"), "ask"),
        ("npm run tn:disable-coupons:dry (permitido)", B("npm run tn:disable-coupons:dry"), None),
        ("npm run tn:variants:list (permitido)", B("npm run tn:variants:list"), None),
        ("npm run tn:validate (permitido)", B("npm run tn:validate"), None),
        ("curl PUT a api.tiendanube", B("curl -X PUT https://api.tiendanube.com/v1/123/products/9 -d '{}'"), "ask"),
        ("curl GET a api.tiendanube (permitido)", B("curl -s https://api.tiendanube.com/v1/123/products"), None),
        ("lftp mirror -R theme", B("lftp -e 'mirror -R ./theme /brasilia' ftp.tiendanube.com"), "ask"),
        ("curl -T a ftp", B("curl -T layout.tpl ftp://ftp.example.com/brasilia/"), "ask"),
        ("sftp", B("sftp user@host"), "ask"),
        ("wrangler deploy", B("npx wrangler deploy", cwd=mine), "ask"),
        ("vercel --prod", B("vercel deploy --prod", cwd=mine), "ask"),
        ("supabase db push", B("supabase db push", cwd=mine), "ask"),
        ("npm run build (permitido)", B("npm run build"), None),
        ("npm run astro:build:tiendanube (permitido)", B("npm run astro:build:tiendanube"), None),
        ("git push origin main en zentra", B("git push origin main"), "ask"),
        ("git push origin HEAD:main en zentra", B("git push origin HEAD:main"), "ask"),
        ("git push rama propia en zentra (permitido)", B("git push origin nacho/onboarding"), None),
        ("git push -u origin proto/x en zentra (permitido)", B("git push -u origin proto/x"), None),
        ("git push pelado estando en main (repo leotocca de prueba)", B("git push", cwd=tmp), "ask"),
        ("git -C <leotocca> push origin master", B(f"git -C {tmp} push origin master", cwd=mine), "ask"),
        ("git push origin main en repo propio (permitido)", B("git push origin main", cwd=mine), None),
        ("gh pr merge en zentra", B("gh pr merge 12 --squash"), "ask"),
        ("opencode run en zentra -> deny", B("opencode run 'refactor ficha'"), "deny"),
        ("cd zentra && opencode -> deny", B("cd ~/projects/zentra && opencode run x", cwd=mine), "deny"),
        ("opencode run en repo propio (permitido)", B("opencode run 'buscar docs'", cwd=mine), None),
        ("git status (permitido)", B("git status"), None),
        ("UserPromptSubmit /hotfix", {"hook_event_name": "UserPromptSubmit", "prompt": "/hotfix el precio de la Z20"}, "context"),
        ("UserPromptSubmit normal", {"hook_event_name": "UserPromptSubmit", "prompt": "hola"}, None),
    ]
    for n, ev, exp in zcases:
        case(Z, n, ev, exp)

print(f"\n{total - fails}/{total} OK")
sys.exit(1 if fails else 0)
