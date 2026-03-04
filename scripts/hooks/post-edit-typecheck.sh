#!/bin/bash
# TypeScript 文件编辑后异步类型检查
# 通过 TOOL_INPUT 环境变量获取编辑的文件路径

FILE=$(echo "$TOOL_INPUT" | node -e "
  try {
    const i = JSON.parse(require('fs').readFileSync('/dev/stdin', 'utf8'));
    console.log(i.file_path || '');
  } catch(e) {}
")

if [[ "$FILE" == *.ts || "$FILE" == *.tsx ]] && command -v bun &>/dev/null; then
  # 找到最近的 tsconfig.json
  DIR=$(dirname "$FILE")
  while [[ "$DIR" != "/" && ! -f "$DIR/tsconfig.json" ]]; do
    DIR=$(dirname "$DIR")
  done

  if [[ -f "$DIR/tsconfig.json" ]]; then
    cd "$DIR" && bun tsc --noEmit --pretty 2>&1 | head -20
  fi
fi
