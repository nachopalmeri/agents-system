// zentra-guard (OpenCode, global). Instalado por Dev Radar 14/11/2026.
// 1) Zentra: mientras Leo no apruebe, OpenCode (DeepSeek / modelos gratis) no trabaja en repos de
//    leotocca/Zentra. Si la sesión arranca dentro de uno (o una tool apunta a uno), bloquea la tool.
// 2) Secretos: bloquea read/grep/glob/edit/shell que toquen .env*, *.pem, *.key, credenciales,
//    ~/.config/secrets, ~/.aws, keys de Tiendanube/Supabase/Cloudflare. Reglas en
//    ~/.config/opencode/zentra-guard/secret-rules.json (mismas que el hook de Claude Code).
// Rollback: borrar este archivo (ver C:\Users\Nacho\.claude\ROLLBACK-guardrails-20261114.txt).
import { readFileSync, existsSync } from "node:fs"
import { homedir } from "node:os"
import { join, dirname } from "node:path"

const ZENTRA_MSG = "Bloqueado por zentra-guard: OpenCode (DeepSeek / modelos gratis) no se usa en repos de Zentra/leotocca hasta que Leo lo apruebe. Usá Claude Code con la cuenta de Zentra."
const ZENTRA_RX = [
  /(^|\/)\/?(wsl\$|wsl\.localhost)\/ubuntu\/home\/nacho\/projects\/zentra(\/|$)/,
  /(^|[\s'"=(])\/home\/nacho\/projects\/zentra(\/|$|[\s'";&|)])/,
  /(^|[\s'"=(])(~|\$home)\/projects\/zentra(\/|$|[\s'";&|)])/,
  /zentra-tiendanube/,
  /github\.com[/:]leotocca\//,
]

function norm(p) {
  let s = String(p ?? "").trim().replace(/^['"`]+|['"`]+$/g, "").replace(/\\/g, "/").toLowerCase()
  const unc = s.startsWith("//")
  s = s.replace(/\/+/g, "/")
  if (unc) s = "/" + s
  return s.length > 1 ? s.replace(/\/$/, "") : s
}

function loadRules() {
  try {
    const f = join(homedir(), ".config", "opencode", "zentra-guard", "secret-rules.json")
    const r = JSON.parse(readFileSync(f, "utf8"))
    return {
      pats: r.path_patterns.map((p) => new RegExp(p)),
      safe: new Set(r.safe_bash_verbs),
      envPrint: new RegExp(String.raw`\b(echo|printf|print|printenv|write-output|write-host)\b[^|;&\n]*?\$(\{)?(env:)?` + r.env_var_name, "i"),
      envDump: /(^|[;&|]\s*)(env|printenv|export\s+-p|set|get-childitem\s+env:|gci\s+env:|dir\s+env:|ls\s+env:)\s*($|[|;&>)])/i,
    }
  } catch {
    return null
  }
}

const gitCache = new Map()
function repoIsLeo(dir) {
  if (!dir) return false
  let d = String(dir)
  if (gitCache.has(d)) return gitCache.get(d)
  let res = false
  try {
    for (let i = 0; i < 12 && d; i++) {
      const cfg = join(d, ".git", "config")
      if (existsSync(cfg)) { res = /leotocca/i.test(readFileSync(cfg, "utf8")); break }
      const up = dirname(d)
      if (up === d) break
      d = up
    }
  } catch { res = false }
  gitCache.set(String(dir), res)
  return res
}

function isZentra(value) {
  const n = norm(value)
  return !!n && ZENTRA_RX.some((rx) => rx.test(n))
}

function secretPath(rules, p) {
  const n = norm(p)
  return !!n && rules.pats.some((rx) => rx.test(n))
}

function secretGlob(rules, p) {
  const n = norm(p)
  return /(^|\/)\.env/.test(n) || secretPath(rules, n.replace(/\*\*/g, "x").replace(/[*?]/g, "x"))
}

function firstVerb(seg) {
  const w = seg.trim().split(/\s+/)
  while (w.length && (/^[A-Za-z_][A-Za-z0-9_]*=/.test(w[0]) || ["sudo", "command", "env", "time", "nohup"].includes(w[0]))) w.shift()
  return w.length ? w[0].toLowerCase().split("/").pop() : ""
}

function secretShell(rules, cmd) {
  if (rules.envPrint.test(cmd) || rules.envDump.test(cmd)) return true
  for (const seg of cmd.split(/\|\||&&|[;|&\n]/)) {
    if (!seg.trim()) continue
    const toks = seg.match(/[\w~.$/\\:-]+/g) || []
    if (toks.some((t) => secretPath(rules, t)) && !rules.safe.has(firstVerb(seg))) return true
  }
  return false
}

function strings(obj, out = [], depth = 0) {
  if (depth > 3 || obj == null) return out
  if (typeof obj === "string") out.push(obj)
  else if (Array.isArray(obj)) obj.forEach((v) => strings(v, out, depth + 1))
  else if (typeof obj === "object") Object.values(obj).forEach((v) => strings(v, out, depth + 1))
  return out
}

function checkTool(rules, tool, args, sessionDirs = []) {
  const t = String(tool || "").toLowerCase()
  args = args || {}
  if (sessionDirs.some((d) => isZentra(d) || repoIsLeo(d))) return ZENTRA_MSG
  const vals = strings(args)
  if (vals.some((v) => isZentra(v))) return ZENTRA_MSG
  for (const k of ["workdir", "cwd", "directory", "path", "filePath", "file_path"]) {
    if (typeof args[k] === "string" && /[\\/]/.test(args[k]) && repoIsLeo(args[k])) return ZENTRA_MSG
  }
  if (!rules) {
    if (["bash", "shell", "read", "grep", "glob", "edit", "write", "patch"].includes(t))
      return "zentra-guard: no pude cargar ~/.config/opencode/zentra-guard/secret-rules.json; bloqueo por seguridad."
    return null
  }
  const why = "Bloqueado por zentra-guard: no se leen archivos ni variables con secretos (.env, keys, credenciales). Usá .env.example."
  if (t === "bash" || t === "shell") return secretShell(rules, String(args.command ?? "")) ? why : null
  if (["read", "edit", "write", "patch"].includes(t)) {
    const p = args.filePath ?? args.file_path ?? args.path
    return p && secretPath(rules, p) ? why : null
  }
  if (t === "grep") return (args.path && secretPath(rules, args.path)) || (args.include && secretGlob(rules, args.include)) || (args.glob && secretGlob(rules, args.glob)) ? why : null
  if (t === "glob") return (args.pattern && secretGlob(rules, args.pattern)) || (args.path && secretPath(rules, args.path)) ? why : null
  return null
}

export const ZentraGuard = async (ctx = {}) => {
  const rules = loadRules()
  const sessionDirs = [ctx?.directory, ctx?.worktree, ctx?.project?.worktree, ctx?.project?.directory].filter((d) => typeof d === "string" && d)
  return {
    "tool.execute.before": async (input, output) => {
      const reason = checkTool(rules, input?.tool, output?.args ?? input?.args, sessionDirs)
      if (reason) throw new Error(reason)
    },
  }
}

// Solo para tests (no es un export: OpenCode trata cada export como plugin).
ZentraGuard._test = { isZentra, checkTool, loadRules }
