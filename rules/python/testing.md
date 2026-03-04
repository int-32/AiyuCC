---
paths:
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/conftest.py"
  - "**/pytest.ini"
  - "**/pyproject.toml"
---

# Python 测试规范

## 工具

- 框架: pytest + pytest-asyncio
- HTTP 测试: httpx.AsyncClient (FastAPI TestClient)
- Mock: unittest.mock / pytest-mock
- 覆盖率: pytest-cov

## FastAPI 测试模式

```python
@pytest.fixture
async def client(app: FastAPI) -> AsyncGenerator[AsyncClient, None]:
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac

async def test_create_user(client: AsyncClient):
    response = await client.post("/users", json={"name": "test"})
    assert response.status_code == 201
```

## Fixture 组织

- 通用 fixture 放 `conftest.py`
- 数据库 fixture: 每个测试使用独立事务并回滚
- 使用 `@pytest.fixture(scope="session")` 共享昂贵资源

## 异步测试

- 使用 `@pytest.mark.asyncio` 标记异步测试
- `pyproject.toml` 中配置 `asyncio_mode = "auto"`

## 命名

- 文件: `test_<module>.py`
- 函数: `test_should_<expected_behavior>_when_<condition>`
