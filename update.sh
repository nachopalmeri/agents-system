#!/usr/bin/env bash
# Script para actualizar el sistema despuÃ©s de hacer git pull
# Ejecutar desde: ~/agents-system/

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

AGENTS_DIR="$HOME/.agents"
BIN_DIR="$HOME/bin"
OPENCODE_DIR="$HOME/.config/opencode"

echo -e "${CYAN}=== Updating local agents system ===${NC}"
echo ""

# Detectar si se usan symlinks o copias
USING_SYMLINKS=false
if [ -L "$AGENTS_DIR" ]; then
    USING_SYMLINKS=true
fi

if [ "$USING_SYMLINKS" = true ]; then
    echo -e "${GREEN}Mode: Symlinks (git pull already activates changes)${NC}"
    echo ""
    echo -e "${YELLOW}Verification:${NC}"

    AGENTS_TARGET=$(readlink "$AGENTS_DIR")
    if echo "$AGENTS_TARGET" | grep -q "agents-system"; then
        echo -e "${GREEN}  [OK] ~/.agents -> $AGENTS_TARGET${NC}"
    else
        echo -e "${YELLOW}  [WARN] ~/.agents points to: $AGENTS_TARGET${NC}"
    fi

    if [ -L "$BIN_DIR" ]; then
        BIN_TARGET=$(readlink "$BIN_DIR")
        if echo "$BIN_TARGET" | grep -q "agents-system"; then
            echo -e "${GREEN}  [OK] ~/bin -> $BIN_TARGET${NC}"
        else
            echo -e "${YELLOW}  [WARN] ~/bin points to: $BIN_TARGET${NC}"
        fi
    fi
else
    echo -e "${YELLOW}Mode: Copies (manual sync required)${NC}"
    echo -e "${GRAY}  Copying updated files...${NC}"

    if [ -d "./.agents" ]; then
        rm -rf "$AGENTS_DIR"
        cp -r "./.agents" "$AGENTS_DIR"
        echo -e "${GREEN}  [OK] ~/.agents updated${NC}"
    fi

    if [ -d "./bin" ]; then
        rm -rf "$BIN_DIR"
        cp -r "./bin" "$BIN_DIR"
        chmod +x "$BIN_DIR/nuevo-proyecto.sh"
        echo -e "${GREEN}  [OK] ~/bin updated${NC}"
    fi

    if [ -d "./config/opencode" ]; then
        mkdir -p "$OPENCODE_DIR"
        cp -r ./config/opencode/* "$OPENCODE_DIR/"
        echo -e "${GREEN}  [OK] OpenCode config updated${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=== Update complete ===${NC}"
echo "Restart your terminal or IDE to ensure changes are loaded."
