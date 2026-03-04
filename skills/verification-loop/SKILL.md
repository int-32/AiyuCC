---
name: verification-loop
description: 验证循环工作流。6 步验证流水线: 构建 > 类型 > lint > 测试 > 安全 > diff 审查。
---

# 验证循环

## 何时激活

- 完成一个功能实现后
- 准备提交代码前
- /verify 命令调用时

## 6 步验证流水线

任一步骤失败则停止，修复后从失败步骤重新开始。

### Step 1: 构建
```bash
# Python
uv build 2>&1 || uv run python -c "import src.package_name"

# TypeScript
bun run build
```

### Step 2: 类型检查
```bash
# Python
uv run pyright .

# TypeScript
bun tsc --noEmit
```

### Step 3: Lint
```bash
# Python
uv run ruff check . && uv run ruff format --check .

# TypeScript
bunx biome check .
```

### Step 4: 测试
```bash
# Python
uv run pytest -v --tb=short

# TypeScript
bun test
```

### Step 5: 安全扫描
- 检查硬编码密钥
- 检查 SQL 注入风险
- 依赖漏洞审计

### Step 6: Diff 审查
```bash
git diff --stat
git diff  # 审查具体变更
```

## 失败处理

- 构建失败 → 使用 build-error-resolver agent
- 类型错误 → 修复类型标注
- Lint 错误 → `ruff check --fix` / `biome check --fix`
- 测试失败 → 分析失败原因，修复代码或测试
- 安全问题 → 立即修复，不跳过
