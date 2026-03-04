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

# 4. Install plugin via marketplace
# 插件安装失败不应中断整个安装流程
set +e
echo ""
echo "Installing plugin..."
if command -v claude &>/dev/null; then
    # 添加本地 marketplace（如果尚未添加）
    if claude plugin marketplace list 2>/dev/null | grep -q "aiyucc-marketplace"; then
        echo "[=] marketplace 'aiyucc-marketplace' already registered"
    else
        claude plugin marketplace add "$SCRIPT_DIR" 2>/dev/null \
            && echo "[+] marketplace 'aiyucc-marketplace' registered" \
            || echo "[!] marketplace registration failed"
    fi

    # 安装插件（如果尚未安装）
    if claude plugin list 2>/dev/null | grep -q "aiyucc@aiyucc-marketplace"; then
        echo "[=] plugin 'aiyucc' already installed, updating..."
        claude plugin update aiyucc@aiyucc-marketplace 2>/dev/null \
            && echo "[+] plugin 'aiyucc' updated" \
            || echo "[!] plugin update failed"
    else
        claude plugin install aiyucc@aiyucc-marketplace 2>/dev/null \
            && echo "[+] plugin 'aiyucc' installed" \
            || echo "[!] plugin installation failed"
    fi
else
    echo "[-] claude command not found, skip plugin installation"
    echo "    Install Claude Code first, then run:"
    echo "    claude plugin marketplace add $SCRIPT_DIR"
    echo "    claude plugin install aiyucc@aiyucc-marketplace"
fi

# 5. Summary
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
echo "Plugin (via marketplace):"
echo "  - agents/    (11 agents)"
echo "  - commands/  (slash commands)"
echo "  - skills/    (11 skills)"
echo "  - hooks/     (5 hooks)"
echo ""
echo "To use context modes:"
echo '  claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'
