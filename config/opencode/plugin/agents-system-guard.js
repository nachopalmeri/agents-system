// Guardia de agents-system para opencode: mismas reglas que ~/.agents/hooks/guard.ps1
// (fuente única: ~/.agents/hooks/guard-rules.json). Bloquea force-push, rm -rf
// peligrosos y lectura de .env lanzando un error antes de ejecutar la herramienta.
import { readFileSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

function isRecord(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

function compileRule(rule) {
  if (!isRecord(rule) || typeof rule.pattern !== "string" || !rule.pattern.trim() ||
      typeof rule.reason !== "string" || !rule.reason.trim()) {
    throw new Error("Invalid rule")
  }
  return { pattern: new RegExp(rule.pattern, "i"), reason: rule.reason }
}

function loadRules() {
  let problem = "missing or unreadable file"
  try {
    const source = readFileSync(join(homedir(), ".agents", "hooks", "guard-rules.json"), "utf8")
    problem = "invalid JSON"
    const rules = JSON.parse(source)
    problem = "invalid schema or regex (requires a non-empty bash array, a readPath rule, and non-empty pattern/reason strings with valid regexes)"
    if (!isRecord(rules) || !Array.isArray(rules.bash) || rules.bash.length === 0) {
      throw new Error("Invalid rules")
    }
    return { rules: { bash: rules.bash.map(compileRule), readPath: compileRule(rules.readPath) } }
  } catch {
    // Never expose raw JSON, patterns, parser errors, or filesystem error details.
    return { error: `Guard rules unavailable: ${problem}. Restore or repair ~/.agents/hooks/guard-rules.json and restart OpenCode before retrying bash/read.` }
  }
}

function checkTool(rules, tool, args) {
  if (!args) return null
  if (tool === "bash") {
    const command = String(args.command ?? "")
    for (const rule of rules.bash) if (rule.pattern.test(command)) return rule.reason
  }
  if (tool === "read") {
    const path = String(args.filePath ?? args.file_path ?? "")
    if (rules.readPath.pattern.test(path)) return rules.readPath.reason
  }
  return null
}

export const AgentsSystemGuard = async () => {
  const { rules, error } = loadRules()
  return {
    "tool.execute.before": async (input, output) => {
      if (error && (input.tool === "bash" || input.tool === "read")) throw new Error(error)
      const reason = checkTool(rules, input.tool, output.args)
      if (reason) throw new Error(`Bloqueado: ${reason}`)
    },
  }
}
