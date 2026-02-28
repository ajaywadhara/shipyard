#!/usr/bin/env bash
set -euo pipefail

# Shipyard — Claude Code Plugin Installer
# Installs skills globally to ~/.claude/skills/ so they work in every project.

BLUE='\033[0;34m'
GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If running via curl pipe, clone to temp dir first
if [ ! -d "$SCRIPT_DIR/skills" ]; then
    echo -e "${BLUE}Downloading Shipyard plugin...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/ajaywadhara/shipyard.git "$TEMP_DIR" 2>/dev/null
    SCRIPT_DIR="$TEMP_DIR"
fi

echo ""
echo -e "${BOLD}Shipyard — Claude Code Plugin Installer${NC}"
echo -e "${DIM}From random thought to shipped product in 10 commands.${NC}"
echo ""

# Create skills directory
mkdir -p "$SKILLS_DIR"

# List of skills to install
SKILLS=(start research wireframe architect build test-ui qa-run fix-bug coverage-review figma-sync)

echo -e "${BLUE}Installing skills to ${SKILLS_DIR}/${NC}"
echo ""

for skill in "${SKILLS[@]}"; do
    if [ -d "$SCRIPT_DIR/skills/$skill" ]; then
        mkdir -p "$SKILLS_DIR/$skill"
        cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
        echo -e "  ${GREEN}✓${NC} /$skill"
    else
        echo -e "  ⚠ /$skill — source not found, skipping"
    fi
done

echo ""
echo -e "${GREEN}${BOLD}Done!${NC} 10 commands installed globally."
echo ""
echo -e "Your workflow:"
echo -e "  ${DIM}1.${NC} Open Claude Code in any project folder"
echo -e "  ${DIM}2.${NC} Type ${BOLD}/start${NC} and describe your idea"
echo -e "  ${DIM}3.${NC} Follow the prompts: /research → /wireframe → /architect"
echo -e "  ${DIM}4.${NC} Build features: ${BOLD}/build [feature-name]${NC}"
echo -e "  ${DIM}5.${NC} Test features:  ${BOLD}/qa-run [feature-name]${NC}"
echo ""
echo -e "${DIM}To install per-project instead:${NC}"
echo -e "${DIM}  cp -r skills/ your-project/.claude/skills/${NC}"
echo ""

# Clean up temp dir if we created one
if [ -n "${TEMP_DIR:-}" ] && [ -d "${TEMP_DIR:-}" ]; then
    rm -rf "$TEMP_DIR"
fi
