#!/usr/bin/env bash
set -euo pipefail

# Shipyard — Claude Code Plugin Installer
# Installs skills globally to ~/.claude/skills/ so they work in every project.

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

SKILLS_DIR="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/skills/.shipyard-backup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHIPYARD_VERSION="1.2.0"

# List of skills to install
SKILLS=(start research wireframe architect build review test-ui qa-run fix-bug coverage-review ship status figma-sync)

# ── Handle --uninstall flag ──────────────────────────────────────────────
if [[ "${1:-}" == "--uninstall" ]]; then
    echo ""
    echo -e "${BOLD}Shipyard — Uninstaller${NC}"
    echo ""

    removed=0
    for skill in "${SKILLS[@]}"; do
        if [ -d "$SKILLS_DIR/$skill" ]; then
            rm -rf "$SKILLS_DIR/$skill"
            echo -e "  ${RED}✗${NC} /$skill removed"
            ((removed++))
        fi
    done

    # Clean up backup directory
    if [ -d "$BACKUP_DIR" ]; then
        rm -rf "$BACKUP_DIR"
        echo -e "  ${DIM}Backup directory removed${NC}"
    fi

    echo ""
    if [ "$removed" -gt 0 ]; then
        echo -e "${GREEN}${BOLD}Done!${NC} Removed $removed Shipyard skills."
    else
        echo -e "${DIM}No Shipyard skills were installed.${NC}"
    fi
    echo ""
    exit 0
fi

# ── If running via curl pipe, clone to temp dir first ────────────────────
if [ ! -d "$SCRIPT_DIR/skills" ]; then
    echo -e "${BLUE}Downloading Shipyard plugin...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/ajaywadhara/shipyard.git "$TEMP_DIR" 2>/dev/null
    SCRIPT_DIR="$TEMP_DIR"
fi

echo ""
echo -e "${BOLD}Shipyard — Claude Code Plugin Installer${NC}"
echo -e "${DIM}From random thought to shipped product in 13 commands.${NC}"
echo ""

# ── Detect existing installation ─────────────────────────────────────────
existing_skills=()
new_skills=()
updated_skills=()

for skill in "${SKILLS[@]}"; do
    if [ -f "$SKILLS_DIR/$skill/SKILL.md" ]; then
        existing_skills+=("$skill")
        # Check if source file differs from installed
        if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
            if ! diff -q "$SKILLS_DIR/$skill/SKILL.md" "$SCRIPT_DIR/skills/$skill/SKILL.md" >/dev/null 2>&1; then
                updated_skills+=("$skill")
            fi
        fi
    else
        if [ -d "$SCRIPT_DIR/skills/$skill" ]; then
            new_skills+=("$skill")
        fi
    fi
done

# ── Show what will happen ────────────────────────────────────────────────
if [ ${#existing_skills[@]} -gt 0 ]; then
    echo -e "${YELLOW}Existing installation detected (${#existing_skills[@]} skills installed)${NC}"
    echo ""

    if [ ${#updated_skills[@]} -gt 0 ]; then
        echo -e "  Skills with updates:"
        for skill in "${updated_skills[@]}"; do
            echo -e "    ${YELLOW}↻${NC} /$skill"
        done
        echo ""
    fi

    if [ ${#new_skills[@]} -gt 0 ]; then
        echo -e "  New skills to add:"
        for skill in "${new_skills[@]}"; do
            echo -e "    ${GREEN}+${NC} /$skill"
        done
        echo ""
    fi

    if [ ${#updated_skills[@]} -eq 0 ] && [ ${#new_skills[@]} -eq 0 ]; then
        echo -e "  ${DIM}All skills are already up to date.${NC}"
        echo ""
        exit 0
    fi

    # ── Prompt for confirmation (unless --force) ─────────────────────────
    if [[ "${1:-}" != "--force" ]]; then
        echo -e "  Existing skills will be backed up to:"
        echo -e "  ${DIM}$BACKUP_DIR/${NC}"
        echo ""
        read -rp "  Continue? [Y/n] " confirm
        if [[ "$confirm" =~ ^[Nn] ]]; then
            echo -e "\n  ${DIM}Aborted.${NC}"
            exit 0
        fi
    fi

    # ── Back up existing skills ──────────────────────────────────────────
    backup_timestamp=$(date +%Y%m%d-%H%M%S)
    backup_path="$BACKUP_DIR/$backup_timestamp"
    mkdir -p "$backup_path"

    for skill in "${existing_skills[@]}"; do
        if [ -d "$SKILLS_DIR/$skill" ]; then
            cp -r "$SKILLS_DIR/$skill" "$backup_path/$skill"
        fi
    done
    echo -e "  ${DIM}Backed up ${#existing_skills[@]} skills to $backup_path/${NC}"
    echo ""
fi

# ── Create skills directory ──────────────────────────────────────────────
mkdir -p "$SKILLS_DIR"

# ── Install skills ───────────────────────────────────────────────────────
echo -e "${BLUE}Installing skills to ${SKILLS_DIR}/${NC}"
echo ""

installed=0
for skill in "${SKILLS[@]}"; do
    if [ -d "$SCRIPT_DIR/skills/$skill" ]; then
        mkdir -p "$SKILLS_DIR/$skill"
        cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
        echo -e "  ${GREEN}✓${NC} /$skill"
        ((installed++))
    else
        echo -e "  ⚠ /$skill — source not found, skipping"
    fi
done

echo ""
echo -e "${GREEN}${BOLD}Done!${NC} $installed commands installed globally (v$SHIPYARD_VERSION)."

if [ ${#new_skills[@]} -gt 0 ]; then
    echo ""
    echo -e "  ${GREEN}New:${NC} ${new_skills[*]}"
fi
if [ ${#updated_skills[@]} -gt 0 ]; then
    echo ""
    echo -e "  ${YELLOW}Updated:${NC} ${updated_skills[*]}"
fi

echo ""
echo -e "Your workflow:"
echo -e "  ${DIM}1.${NC} Open Claude Code in any project folder"
echo -e "  ${DIM}2.${NC} Type ${BOLD}/start${NC} and describe your idea"
echo -e "  ${DIM}3.${NC} Follow the prompts: /research → /wireframe → /architect"
echo -e "  ${DIM}4.${NC} Build features: ${BOLD}/build [feature-name]${NC}"
echo -e "  ${DIM}5.${NC} Review code:    ${BOLD}/review [feature-name]${NC}"
echo -e "  ${DIM}6.${NC} Test features:  ${BOLD}/qa-run [feature-name]${NC}"
echo -e "  ${DIM}7.${NC} Ship it:        ${BOLD}/ship${NC}"
echo -e "  ${DIM}8.${NC} Check progress: ${BOLD}/status${NC}"
echo ""
echo -e "${DIM}To install per-project instead:${NC}"
echo -e "${DIM}  cp -r skills/ your-project/.claude/skills/${NC}"
echo ""
echo -e "${DIM}To uninstall: bash install.sh --uninstall${NC}"
echo ""

# Clean up temp dir if we created one
if [ -n "${TEMP_DIR:-}" ] && [ -d "${TEMP_DIR:-}" ]; then
    rm -rf "$TEMP_DIR"
fi
