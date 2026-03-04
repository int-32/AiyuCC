#!/bin/bash
# Python 文件编辑后自动 ruff format + check
# 通过 TOOL_INPUT 环境变量获取编辑的文件路径

FILE=$(echo "$TOOL_INPUT" | node -e "
  try {
    const i = JSON.parse(require('fs').readFileSync('/dev/stdin', 'utf8'));
    console.log(i.file_path || '');
  } catch(e) {}
")

if [[ "$FILE" == *.py ]] && command -v ruff &>/dev/null; then
  ruff format --quiet "$FILE" 2>/dev/null
  ruff check --fix --quiet "$FILE" 2>/dev/null
fi
