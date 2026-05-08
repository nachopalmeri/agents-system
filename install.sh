#!/usr/bin/env bash
# Install script for agents-system on Linux/Mac
# Run: curl -fsSL https://raw.githubusercontent.com/nachopalmeri/agents-system/main/install.sh | bash

set -e

REPO_URL="${REPO_URL:-https://github.com/nachopalmeri/agents-system.git}"
BRANCH="${BRANCH:-main}"
INSTALL_DIR="$HOME/agents-system"

echo "=== Agents System Installer ==="
echo "Installing from: $REPO_URL"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# 1. Clone or update repo
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}Directory exists. Updating...${NC}"
    cd "$INSTALL_DIR"
    git pull origin "$BRANCH"
else
    echo -e "${GREEN}Cloning repository to $INSTALL_DIR...${NC}"
    git clone --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

# 2. Backup existing directories if they exist and are not symlinks
AGENTS_DIR="$HOME/.agents"
BIN_DIR="$HOME/bin"

backup_if_needed() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}-backup-$(date +%Y%m%d-%H%M%S)"
        echo -e "${YELLOW}Backing up existing $(basename $target) to $backup...${NC}"
        mv "$target" "$backup"
    fi
}

backup_if_needed "$AGENTS_DIR"
backup_if_needed "$BIN_DIR"

# 3. Create symlinks
echo -e "${GREEN}Creating symbolic links...${NC}"

# Remove existing symlinks if broken
[ -L "$AGENTS_DIR" ] && [ ! -e "$AGENTS_DIR" ] && rm "$AGENTS_DIR"
[ -L "$BIN_DIR" ] && [ ! -e "$BIN_DIR" ] && rm "$BIN_DIR"

# Create new symlinks
ln -sf "$INSTALL_DIR/.agents" "$AGENTS_DIR"
echo -e "${GRAY}  ✓ ~/.agents -> agents-system/.agents${NC}"

ln -sf "$INSTALL_DIR/bin" "$BIN_DIR"
echo -e "${GRAY}  ✓ ~/bin -> agents-system/bin${NC}"

# 4. Ensure ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo -e "${GREEN}Adding ~/bin to PATH...${NC}"
    
    # Detect shell
    if [ -n "$ZSH_VERSION" ] || [ "$(basename $SHELL)" = "zsh" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ "$(basename $SHELL)" = "bash" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
    echo -e "${GRAY}  ✓ Added to $SHELL_RC (restart terminal or run: source $SHELL_RC)${NC}"
else
    echo -e "${GRAY}  ✓ ~/bin already in PATH${NC}"
fi

# 5. Copy OpenCode config
OPENCODE_DIR="$HOME/.config/opencode"
OPENCODE_SOURCE="$INSTALL_DIR/config/opencode"
if [ -d "$OPENCODE_SOURCE" ]; then
    mkdir -p "$OPENCODE_DIR"
    cp -r "$OPENCODE_SOURCE/"* "$OPENCODE_DIR/"
    echo -e "${GRAY}  ✓ Copied OpenCode config${NC}"
fi

# 6. Verify installation
echo ""
echo "=== Verification ==="

CHECKS=(
    "$AGENTS_DIR: ~/.agents"
    "$BIN_DIR/nuevo-proyecto.sh: ~/bin/nuevo-proyecto.sh"
)

ALL_OK=true
for check in "${CHECKS[@]}"; do
    IFS=':' read -r path name <<< "$check"
    if [ -e "$path" ]; then
        echo -e "${GREEN}  ✓ $name${NC}"
    else
        echo -e "${RED}  ✗ $name MISSING${NC}"
        ALL_OK=false
    fi
done

# Check PowerShell script exists (for WSL compatibility)
if [ -f "$BIN_DIR/nuevo-proyecto.ps1" ]; then
    echo -e "${GREEN}  ✓ ~/bin/nuevo-proyecto.ps1 (for Windows)${NC}"
fi

echo ""
if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}=== Installation Complete ===${NC}"
    echo ""
    echo "Test it:"
    echo -e "${YELLOW}  nuevo-proyecto test-install astro${NC}"
    echo ""
    echo "Then:"
    echo -e "${GRAY}  cd ~/test-install${NC}"
    echo -e "${GRAY}  opencode  # or zed, or code .${NC}"
    echo ""
else
    echo -e "${RED}=== Installation Incomplete ===${NC}"
    echo "Some files are missing. Check errors above."
fi

echo ""
echo -e "${GRAY}Repository location: $INSTALL_DIR${NC}"
echo -e "${GRAY}To update later: cd $INSTALL_DIR && git pull${NC}"
