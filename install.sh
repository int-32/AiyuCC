#!/bin/bash
# AiyuCC 安装脚本
# 安装插件无法自动加载的组件: rules, CLAUDE.md, contexts

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "AiyuCC Installer"
echo "================"
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# 1. Install CLAUDE.md
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "[!] ~/.claude/CLAUDE.md already exists."
    read -p "    Overwrite? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
        echo "[+] CLAUDE.md installed"
    else
        echo "[-] CLAUDE.md skipped"
    fi
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "[+] CLAUDE.md installed"
fi

# 2. Install rules (preserve directory structure)
echo ""
echo "Installing rules..."
for lang_dir in common python typescript; do
    src="$SCRIPT_DIR/rules/$lang_dir"
    dst="$CLAUDE_DIR/rules/$lang_dir"
    if [ -d "$src" ]; then
        mkdir -p "$dst"
        cp "$src"/*.md "$dst/" 2>/dev/null || true
        echo "[+] rules/$lang_dir/ installed ($(ls "$src"/*.md 2>/dev/null | wc -l | tr -d ' ') files)"
    fi
done

# 3. Install contexts
echo ""
echo "Installing contexts..."
mkdir -p "$CLAUDE_DIR/contexts"
if [ -d "$SCRIPT_DIR/contexts" ]; then
    cp "$SCRIPT_DIR/contexts"/*.md "$CLAUDE_DIR/contexts/" 2>/dev/null || true
    echo "[+] contexts/ installed ($(ls "$SCRIPT_DIR/contexts"/*.md 2>/dev/null | wc -l | tr -d ' ') files)"
fi

# 4. Summary
echo ""
echo "Installation complete!"
echo ""
echo "Installed:"
echo "  - CLAUDE.md          (global instructions)"
echo "  - rules/common/      (always-on rules)"
echo "  - rules/python/      (Python rules, path-scoped)"
echo "  - rules/typescript/  (TypeScript rules, path-scoped)"
echo "  - contexts/          (system prompt modes)"
echo ""
echo "Auto-loaded by plugin:"
echo "  - agents/   (11 agents)"
echo "  - commands/  (slash commands)"
echo "  - skills/   (11 skills)"
echo "  - hooks/    (5 hooks)"
echo ""
echo "To install the plugin itself:"
echo "  claude plugin install $SCRIPT_DIR"
echo ""
echo "To use context modes:"
echo '  claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'
