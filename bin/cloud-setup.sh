#!/usr/bin/env bash
# Setup de agents-system para entornos cloud de Claude Code (contenedores efímeros).
# Pegalo como "Setup script" del entorno para que cada sesión nueva arranque con
# reglas, skills, agentes, comandos y hooks instalados. Idempotente.
#   curl -fsSL https://raw.githubusercontent.com/nachopalmeri/agents-system/main/bin/cloud-setup.sh | bash
# Variables opcionales: BRANCH (default main), REPO_DIR (default ~/agents-system),
# ACCEPT_TERMS (ej. "tesseract,anthropic-docs" para instalar skills con términos propios).
set -euo pipefail

BRANCH="${BRANCH:-main}"
REPO_URL="${REPO_URL:-https://github.com/nachopalmeri/agents-system}"
REPO_DIR="${REPO_DIR:-$HOME/agents-system}"
PWSH_VERSION="${PWSH_VERSION:-7.4.6}"

# 1. PowerShell 7 (los scripts del sistema y los hooks lo usan)
if ! command -v pwsh >/dev/null 2>&1; then
  arch="x64"; [ "$(uname -m)" = "aarch64" ] && arch="arm64"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/pwsh.tgz" "https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/powershell-${PWSH_VERSION}-linux-${arch}.tar.gz"
  mkdir -p /opt/pwsh && tar xzf "$tmp/pwsh.tgz" -C /opt/pwsh && chmod +x /opt/pwsh/pwsh
  ln -sf /opt/pwsh/pwsh /usr/local/bin/pwsh
  rm -rf "$tmp"
fi

# 2. Repo del sistema
if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" fetch --depth 1 origin "$BRANCH" && git -C "$REPO_DIR" checkout -q -B "$BRANCH" FETCH_HEAD
else
  git clone -q --depth 1 --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
fi

# 3. Instalar (merge: conserva lo ajeno; -Force reemplaza sólo lo del repo, con backup)
pwsh -NoProfile -File "$REPO_DIR/bin/sync-runtime.ps1" -HomePath "$HOME" -Force
pwsh -NoProfile -File "$REPO_DIR/bin/install-external-skills.ps1" -HomePath "$HOME" ${ACCEPT_TERMS:+-AcceptTerms "$ACCEPT_TERMS"} || echo "aviso: skills externas no instaladas (red?)"

# 4. Verificar
pwsh -NoProfile -File "$REPO_DIR/bin/sync-runtime.ps1" -HomePath "$HOME" -Check
