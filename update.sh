#!/usr/bin/env bash
# Script para actualizar el sistema después de hacer git pull
# Ejecutar desde: ~/agents-system/

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

echo -e "${CYAN}=== Actualizando sistema local ===${NC}"
echo ""

# Detectar si se usan symlinks o copias
AGENTS_DIR="$HOME/.agents"
BIN_DIR="$HOME/bin"
USING_SYMLINKS=false

if [ -L "$AGENTS_DIR" ]; then
    USING_SYMLINKS=true
fi

if [ "$USING_SYMLINKS" = true ]; then
    echo -e "${GREEN}Modo: Symlinks (los cambios ya están activos)${NC}"
    echo -e "${GRAY}  Los symlinks apuntan a esta carpeta, así que git pull = actualización inmediata${NC}"
    echo ""
    echo -e "${YELLOW}Verificación:${NC}"
    
    AGENTS_TARGET=$(readlink "$AGENTS_DIR")
    if echo "$AGENTS_TARGET" | grep -q "agents-system"; then
        echo -e "${GREEN}  ✓ ~/.agents -> $AGENTS_TARGET${NC}"
    else
        echo -e "${YELLOW}  ⚠ ~/.agents symlink apunta a: $AGENTS_TARGET${NC}"
    fi
    
    BIN_TARGET=$(readlink "$BIN_DIR")
    if echo "$BIN_TARGET" | grep -q "agents-system"; then
        echo -e "${GREEN}  ✓ ~/bin -> $BIN_TARGET${NC}"
    else
        echo -e "${YELLOW}  ⚠ ~/bin symlink apunta a: $BIN_TARGET${NC}"
    fi
else
    echo -e "${YELLOW}Modo: Copias (necesita sincronización manual)${NC}"
    echo -e "${GRAY}  Copiando archivos actualizados...${NC}"
    
    if [ -d "./.agents" ]; then
        rm -rf "$AGENTS_DIR"
        cp -r "./.agents" "$AGENTS_DIR"
        echo -e "${GREEN}  ✓ ~/.agents actualizado${NC}"
    fi
    
    if [ -d "./bin" ]; then
        rm -rf "$BIN_DIR"
        cp -r "./bin" "$BIN_DIR"
        chmod +x "$BIN_DIR/nuevo-proyecto.sh"
        echo -e "${GREEN}  ✓ ~/bin actualizado${NC}"
    fi
    
    if [ -d "./config/opencode" ]; then
        mkdir -p "$HOME/.config/opencode"
        cp -r ./config/opencode/* "$HOME/.config/opencode/"
        echo -e "${GREEN}  ✓ ~/.config/opencode actualizado${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=== Actualización completa ===${NC}"
echo "Reiniciá tu terminal/IDE para asegurar cambios cargados."
