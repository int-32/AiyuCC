---
paths:
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/tests/**"
  - "**/*.test.ts"
  - "**/*.spec.ts"
  - "**/__tests__/**"
  - "**/conftest.py"
  - "**/pytest.ini"
  - "**/vitest.config.*"
---

# 测试规范

## TDD 工作流

严格遵循 RED-GREEN-REFACTOR:

1. **RED** — 先写失败的测试，明确期望行为
2. **GREEN** — 写最少代码让测试通过
3. **REFACTOR** — 在测试保护下重构

## 覆盖率要求

- 最低 **80%** 覆盖率
- 认证、支付、安全相关代码要求 **100%** 覆盖
- 关键流程需要单元 + 集成 + E2E 三层测试

## 测试原则

- 测试行为而非实现细节
- 每个测试独立（无共享状态）
- 测试命名描述预期行为: `test_should_return_error_when_input_invalid`
- 使用 arrange-act-assert 模式
- Mock 外部依赖（数据库、API、文件系统）

## 工具

- Python: pytest + pytest-asyncio + httpx (FastAPI 测试)
- TypeScript: vitest / bun test + @testing-library/react + Playwright (E2E)
