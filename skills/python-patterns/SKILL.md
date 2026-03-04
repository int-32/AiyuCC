---
name: python-patterns
description: Python 深度模式参考。FastAPI + SQLModel + Pydantic v2 + async 最佳实践大全。
disable-model-invocation: true
---

# Python 模式参考

## FastAPI 应用结构

```python
# main.py
from contextlib import asynccontextmanager
from fastapi import FastAPI

@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    await init_db()
    yield
    # shutdown
    await close_db()

app = FastAPI(title="Service", lifespan=lifespan)
app.include_router(users_router, prefix="/api/v1")
```

## SQLModel 模型设计

```python
# 表模型
class User(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    email: str = Field(unique=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)

# 创建 Schema (不带 table=True)
class UserCreate(SQLModel):
    name: str = Field(min_length=1, max_length=100)
    email: EmailStr

# 响应 Schema
class UserRead(SQLModel):
    id: int
    name: str
    email: str
    created_at: datetime

# 更新 Schema
class UserUpdate(SQLModel):
    name: str | None = None
    email: EmailStr | None = None
```

## Pydantic v2 模式

```python
from pydantic import BaseModel, ConfigDict, field_validator, model_validator

class Config(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        frozen=True,  # 不可变
    )

    host: str
    port: int = 8000

    @field_validator("port")
    @classmethod
    def validate_port(cls, v: int) -> int:
        if not 1 <= v <= 65535:
            raise ValueError("port must be 1-65535")
        return v
```

## 依赖注入

```python
from fastapi import Depends
from sqlmodel.ext.asyncio.session import AsyncSession

async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        yield session

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    session: AsyncSession = Depends(get_session),
) -> User:
    payload = decode_token(token)
    user = await session.get(User, payload["sub"])
    if not user:
        raise HTTPException(status_code=401)
    return user

# 使用
@router.get("/me")
async def get_me(user: User = Depends(get_current_user)):
    return user
```

## 异步模式

```python
# 并行执行独立 I/O
results = await asyncio.gather(
    fetch_user(user_id),
    fetch_orders(user_id),
    fetch_notifications(user_id),
)

# 信号量控制并发
sem = asyncio.Semaphore(10)
async def limited_fetch(url: str):
    async with sem:
        return await client.get(url)
```

## Repository 模式

```python
from typing import Protocol

class UserRepository(Protocol):
    async def get_by_id(self, id: int) -> User | None: ...
    async def create(self, data: UserCreate) -> User: ...
    async def list(self, offset: int, limit: int) -> list[User]: ...

class SQLModelUserRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_by_id(self, id: int) -> User | None:
        return await self.session.get(User, id)

    async def create(self, data: UserCreate) -> User:
        user = User.model_validate(data)
        self.session.add(user)
        await self.session.commit()
        await self.session.refresh(user)
        return user
```

## 配置管理

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    secret_key: str
    debug: bool = False

    model_config = ConfigDict(env_file=".env")

settings = Settings()
```

## 错误处理

```python
class AppError(Exception):
    def __init__(self, code: str, message: str, status: int = 400):
        self.code = code
        self.message = message
        self.status = status

@app.exception_handler(AppError)
async def app_error_handler(request: Request, exc: AppError):
    return JSONResponse(
        status_code=exc.status,
        content={
            "success": False,
            "error": {"code": exc.code, "message": exc.message},
        },
    )
```
