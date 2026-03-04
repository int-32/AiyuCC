---
description: 测试驱动开发工作流。强制执行 RED-GREEN-REFACTOR 循环。
---

# /tdd - 测试驱动开发

使用 tdd-guide agent 执行严格的 TDD 工作流。

## 执行步骤

1. **理解需求** — 明确要实现的功能
2. **RED** — 先写一个失败的测试
3. **运行测试** — 确认测试失败（且失败原因正确）
4. **GREEN** — 写最少代码让测试通过
5. **运行测试** — 确认通过
6. **REFACTOR** — 在测试保护下重构
7. **重复** — 下一个测试用例

## 用户参数

$ARGUMENTS

如果用户未提供参数，询问要用 TDD 实现的功能。

## 工具

- Python: `uv run pytest` + pytest-asyncio
- TypeScript: `bun test` / `bunx vitest`
