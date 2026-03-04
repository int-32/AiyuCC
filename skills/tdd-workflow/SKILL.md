---
name: tdd-workflow
description: TDD 完整工作流指导。包含 RED-GREEN-REFACTOR 循环、pytest/vitest 最佳实践、Mock 策略。
---

# TDD 工作流

## 何时激活

- 用户要求实现新功能时
- 用户要求修复 bug 时
- 用户要求添加测试时

## RED-GREEN-REFACTOR 循环

### RED: 写失败的测试

```python
# Python: pytest
def test_should_create_user_with_valid_data():
    user = create_user(name="test", email="test@example.com")
    assert user.id is not None
    assert user.name == "test"
```

```typescript
// TypeScript: vitest
it("should create user with valid data", async () => {
  const user = await createUser({ name: "test", email: "test@example.com" });
  expect(user.id).toBeDefined();
  expect(user.name).toBe("test");
});
```

### GREEN: 最少代码通过

只写让当前测试通过的最少代码，不要提前优化。

### REFACTOR: 改进代码

在测试保护下:
- 消除重复
- 改善命名
- 简化逻辑
- 提取函数

## Mock 策略

### Python
```python
# Mock 数据库
@pytest.fixture
def mock_db(mocker):
    return mocker.AsyncMock(spec=AsyncSession)

# Mock 外部 API
@pytest.fixture
def mock_http(mocker):
    return mocker.patch("httpx.AsyncClient.get")
```

### TypeScript
```typescript
// Mock 模块
vi.mock("./api", () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1, name: "test" }),
}));
```

## 覆盖率

```bash
# Python
uv run pytest --cov=src --cov-report=term-missing --cov-fail-under=80

# TypeScript
bunx vitest run --coverage
```

## 测试分层

| 层级 | 范围 | 速度 | 比例 |
|------|------|------|------|
| 单元测试 | 单个函数/类 | 快 | 70% |
| 集成测试 | 多组件交互 | 中 | 20% |
| E2E 测试 | 完整用户流程 | 慢 | 10% |
