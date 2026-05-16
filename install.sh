#!/usr/bin/env bash
set -e

REPO_URL="${REPO_URL:-https://github.com/nachopalmeri/agents-system.git}"
BRANCH="${BRANCH:-main}"
INSTALL_DIR="$HOME/agents-system"
AGENTS_DIR="$HOME/.agents"
BIN_DIR="$HOME/bin"
OPENCODE_DIR="$HOME/.config/opencode"
OPENCODE_SOURCE="$INSTALL_DIR/config/opencode"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m'

echo "=== Agents System Installer ==="
echo "Installing from: $REPO_URL"
echo ""

if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}Directory exists. Updating...${NC}"
    git -C "$INSTALL_DIR" pull origin "$BRANCH"
else
    echo -e "${GREEN}Cloning repository to $INSTALL_DIR...${NC}"
    git clone --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

backup_if_needed() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}-backup-$(date +%Y%m%d-%H%M%S)"
        echo -e "${YELLOW}Backing up existing $(basename "$target") to $backup...${NC}"
        mv "$target" "$backup"
    fi
}

backup_if_needed "$AGENTS_DIR"
backup_if_needed "$BIN_DIR"

echo -e "${GREEN}Creating symbolic links...${NC}"
[ -L "$AGENTS_DIR" ] && rm "$AGENTS_DIR"
[ -L "$BIN_DIR" ] && rm "$BIN_DIR"
ln -sf "$INSTALL_DIR/.agents" "$AGENTS_DIR"
echo -e "${GRAY}  [OK] ~/.agents -> agents-system/.agents${NC}"
ln -sf "$INSTALL_DIR/bin" "$BIN_DIR"
echo -e "${GRAY}  [OK] ~/bin -> agents-system/bin${NC}"

if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo -e "${GREEN}Adding ~/bin to PATH...${NC}"
    if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ "$(basename "$SHELL")" = "bash" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
    echo -e "${GRAY}  [OK] Added to $SHELL_RC${NC}"
else
    echo -e "${GRAY}  [OK] ~/bin already in PATH${NC}"
fi

if [ -d "$OPENCODE_SOURCE" ]; then
    mkdir -p "$OPENCODE_DIR"
    cp -r "$OPENCODE_SOURCE/"* "$OPENCODE_DIR/"
    echo -e "${GRAY}  [OK] Copied OpenCode config${NC}"
fi

echo ""
echo "=== Verification ==="
ALL_OK=true
if [ -e "$AGENTS_DIR" ]; then
    echo -e "${GREEN}  [OK] ~/.agents${NC}"
else
    echo -e "${RED}  [MISSING] ~/.agents${NC}"
    ALL_OK=false
fi
if [ -e "$BIN_DIR/nuevo-proyecto.sh" ]; then
    echo -e "${GREEN}  [OK] ~/bin/nuevo-proyecto.sh${NC}"
else
    echo -e "${RED}  [MISSING] ~/bin/nuevo-proyecto.sh${NC}"
    ALL_OK=false
fi
if [ -f "$BIN_DIR/nuevo-proyecto.ps1" ]; then
    echo -e "${GREEN}  [OK] ~/bin/nuevo-proyecto.ps1${NC}"
fi

echo ""
if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}=== Installation Complete ===${NC}"
    echo "Test it: nuevo-proyecto test-install astro"
else
    echo -e "${RED}=== Installation Incomplete ===${NC}"
    exit 1
fi

echo ""
echo -e "${GRAY}Repository location: $INSTALL_DIR${NC}"
echo -e "${GRAY}To update later: git -C \"$INSTALL_DIR\" pull origin $BRANCH${NC}"