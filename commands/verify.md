---
description: 综合验证。依次运行构建、类型检查、lint、测试和安全扫描。
---

# /verify - 综合验证

按顺序执行全面验证流水线，任一步骤失败则停止并修复。

## 验证步骤

### 1. 构建检查
- Python: `uv build` 或 `uv run python -m py_compile`
- TypeScript: `bun run build`

### 2. 类型检查
- Python: `uv run pyright` 或 `uv run mypy`
- TypeScript: `bun tsc --noEmit`

### 3. Lint 检查
- Python: `uv run ruff check .`
- TypeScript: `bunx biome check .`

### 4. 测试
- Python: `uv run pytest --cov -v`
- TypeScript: `bun test` / `bunx vitest run`

### 5. 安全扫描
- 检查硬编码密钥: `grep -rn 'password\|secret\|api_key\|token' --include='*.py' --include='*.ts'`
- 依赖审计: `uv audit` / `bun audit`

### 6. Diff 审查
- `git diff` 确认变更范围合理

## 用户参数

$ARGUMENTS

支持: `build`, `types`, `lint`, `test`, `security` — 只运行指定步骤。
