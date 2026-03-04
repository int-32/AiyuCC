---
paths:
  - "**/*.py"
---

# Python 模式规范

## FastAPI 模式

- 路由函数保持精简，业务逻辑放 services 层
- 使用 `Depends()` 依赖注入（认证、数据库会话、配置）
- 异常使用 `HTTPException` 或自定义异常处理器
- 使用 `lifespan` 管理应用生命周期（替代 on_startup/on_shutdown）

## SQLModel 模式

- 表模型: `class User(SQLModel, table=True)`
- 纯 Schema: `class UserCreate(SQLModel)` (不带 table=True)
- 区分 Create/Read/Update schema
- 使用 `select()` 构建查询，避免原始 SQL

## Pydantic v2 模式

- 使用 `model_validator` 替代 `root_validator`
- 使用 `field_validator` 替代 `validator`
- 使用 `model_config = ConfigDict(...)` 替代 `class Config`
- 序列化: `model_dump()` 替代 `dict()`

## 依赖注入

```python
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    ...
```

## 错误处理

- 业务错误使用自定义 Exception 类
- FastAPI 注册全局异常处理器
- 不在路由函数中捕获所有异常
