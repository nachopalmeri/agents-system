// Guardia de agents-system para opencode: mismas reglas que ~/.agents/hooks/guard.ps1
// (fuente única: ~/.agents/hooks/guard-rules.json). Bloquea force-push, rm -rf
// peligrosos y lectura de .env lanzando un error antes de ejecutar la herramienta.
import { readFileSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

function loadRules() {
  try {
    return JSON.parse(readFileSync(join(homedir(), ".agents", "hooks", "guard-rules.json"), "utf8"))
  } catch {
    return null
  }
}

export function checkTool(rules, tool, args) {
  if (!rules || !args) return null
  if (tool === "bash") {
    const command = String(args.command ?? "")
    for (const rule of rules.bash) if (new RegExp(rule.pattern, "i").test(command)) return rule.reason
  }
  if (tool === "read") {
    const path = String(args.filePath ?? args.file_path ?? "")
    if (new RegExp(rules.readPath.pattern, "i").test(path)) return rules.readPath.reason
  }
  return null
}

export const AgentsSystemGuard = async () => {
  const rules = loadRules()
  return {
    "tool.execute.before": async (input, output) => {
      const reason = checkTool(rules, input.tool, output.args)
      if (reason) throw new Error(`Bloqueado: ${reason}`)
    },
  }
}
