#!/bin/bash
# AiyuCC 卸载脚本
# 删除 install.sh 安装到 ~/.claude/ 的文件，卸载插件并移除 marketplace

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "AiyuCC Uninstaller"
echo "=================="
echo ""

# 确认
echo "Will remove from $CLAUDE_DIR:"
echo "  - CLAUDE.md"
echo "  - rules/common/"
echo "  - rules/python/"
echo "  - rules/typescript/"
echo "  - contexts/"
echo "  - Plugin 'aiyucc@aiyucc-marketplace'"
echo "  - Marketplace 'aiyucc-marketplace'"
echo ""
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# 1. Uninstall plugin
# 插件卸载失败不应中断整个流程
set +e
echo "Uninstalling plugin..."
if command -v claude &>/dev/null; then
    claude plugin uninstall aiyucc@aiyucc-marketplace 2>/dev/null \
        && echo "[x] Plugin 'aiyucc' uninstalled" \
        || echo "[-] Plugin not installed or uninstall failed"

    claude plugin marketplace remove aiyucc-marketplace 2>/dev/null \
        && echo "[x] Marketplace 'aiyucc-marketplace' removed" \
        || echo "[-] Marketplace not registered or remove failed"
else
    echo "[-] claude command not found, skip plugin removal"
fi

# 2. Remove CLAUDE.md
echo ""
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    rm "$CLAUDE_DIR/CLAUDE.md"
    echo "[x] CLAUDE.md removed"
else
    echo "[-] CLAUDE.md not found, skipped"
fi

# 3. Remove rules
for lang_dir in common python typescript; do
    dst="$CLAUDE_DIR/rules/$lang_dir"
    if [ -d "$dst" ]; then
        rm -rf "$dst"
        echo "[x] rules/$lang_dir/ removed"
    else
        echo "[-] rules/$lang_dir/ not found, skipped"
    fi
done

# Clean up empty rules/ directory
if [ -d "$CLAUDE_DIR/rules" ] && [ -z "$(ls -A "$CLAUDE_DIR/rules" 2>/dev/null)" ]; then
    rmdir "$CLAUDE_DIR/rules"
    echo "[x] rules/ (empty dir) removed"
fi

# 4. Remove contexts
if [ -d "$CLAUDE_DIR/contexts" ]; then
    rm -rf "$CLAUDE_DIR/contexts"
    echo "[x] contexts/ removed"
else
    echo "[-] contexts/ not found, skipped"
fi

# 5. Summary
echo ""
echo "Uninstall complete!"
echo ""
echo "Removed:"
echo "  - Plugin 'aiyucc@aiyucc-marketplace'"
echo "  - Marketplace 'aiyucc-marketplace'"
echo "  - ~/.claude/CLAUDE.md"
echo "  - ~/.claude/rules/{common,python,typescript}/"
echo "  - ~/.claude/contexts/"
echo ""
echo "Note: ~/.claude/plans/ was preserved (your project plans)."
