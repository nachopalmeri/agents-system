#!/usr/bin/env bash
# Script para copiar tu sistema actual a este repo local
# Ejecutar desde: ~/agents-system/

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'

echo -e "${CYAN}=== Copiando sistema actual al repo ===${NC}"
echo -e "${GRAY}Origen: $HOME${NC}"
echo -e "${GRAY}Destino: $(pwd)${NC}"
echo ""

# 1. Copiar .agents/
echo -e "${YELLOW}[1/3] Copiando ~/.agents ...${NC}"
if [ -d "$HOME/.agents" ]; then
    rm -rf ./.agents 2>/dev/null || true
    cp -r "$HOME/.agents" .
    echo -e "${GREEN}  ✓ .agents copiado${NC}"
else
    echo -e "${RED}  ✗ No se encontró ~/.agents${NC}"
fi

# 2. Copiar bin/
echo -e "${YELLOW}[2/3] Copiando ~/bin ...${NC}"
copied=0
for file in nuevo-proyecto.ps1 nuevo-proyecto.sh; do
    if [ -f "$HOME/bin/$file" ]; then
        cp "$HOME/bin/$file" ./bin/
        echo -e "${GREEN}  ✓ $file copiado${NC}"
        ((copied++)) || true
    else
        echo -e "${RED}  ✗ $file no encontrado${NC}"
    fi
done

if [ $copied -eq 0 ]; then
    echo -e "${YELLOW}  ⚠ No se encontraron scripts en ~/bin${NC}"
fi

# Hacer ejecutable el script bash
if [ -f "./bin/nuevo-proyecto.sh" ]; then
    chmod +x ./bin/nuevo-proyecto.sh
fi

# 3. Copiar config/opencode/
echo -e "${YELLOW}[3/3] Copiando config/opencode ...${NC}"
if [ -d "$HOME/.config/opencode" ]; then
    mkdir -p ./config/opencode
    for file in AGENTS.md opencode.jsonc; do
        if [ -f "$HOME/.config/opencode/$file" ]; then
            cp "$HOME/.config/opencode/$file" ./config/opencode/
            echo -e "${GREEN}  ✓ $file copiado${NC}"
        else
            echo -e "${RED}  ✗ $file no encontrado${NC}"
        fi
    done
else
    echo -e "${YELLOW}  ⚠ No se encontró ~/.config/opencode/${NC}"
fi

# 4. Crear .gitignore si no existe
if [ ! -f ".gitignore" ]; then
    echo -e "${YELLOW}[Extra] Creando .gitignore ...${NC}"
    cat > .gitignore << 'EOF'
# Windows
Thumbs.db
desktop.ini

# macOS
.DS_Store

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Temporal
*.tmp
*.temp
*~

# Never commit these
.env
.env.local
.env.*
*.key
*.pem
secrets/
EOF
    echo -e "${GREEN}  ✓ .gitignore creado${NC}"
fi

echo ""
echo -e "${CYAN}=== Resumen ===${NC}"
echo -e "${WHITE}Ahora ejecuta:${NC}"
echo -e "${YELLOW}  git init${NC}"
echo -e "${YELLOW}  git add .${NC}"
echo -e "${YELLOW}  git commit -m 'feat: sistema inicial de agentes'${NC}"
echo -e "${YELLOW}  gh repo create agents-system --public --source=. --push${NC}"
echo ""
echo -e "${GRAY}O manualmente:${NC}"
echo -e "${GRAY}  1. Crear repo en https://github.com/new${NC}"
echo -e "${GRAY}  2. git remote add origin https://github.com/TU-USUARIO/agents-system.git${NC}"
echo -e "${GRAY}  3. git push -u origin main${NC}"
echo ""
echo -e "${YELLOW}Luego actualiza TU-USUARIO en:${NC}"
echo -e "${GRAY}  - install.ps1 (línea con github.com/TU-USUARIO)${NC}"
echo -e "${GRAY}  - install.sh (línea con github.com/TU-USUARIO)${NC}"
echo -e "${GRAY}  - README.md (todas las URLs)${NC}"
