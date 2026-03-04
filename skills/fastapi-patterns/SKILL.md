---
name: fastapi-patterns
description: FastAPI 深度最佳实践。路由设计、中间件、依赖注入、异步模式、部署配置。
disable-model-invocation: true
---

# FastAPI 最佳实践

## 路由组织

```python
# routers/users.py
from fastapi import APIRouter, Depends, HTTPException, status

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/", response_model=list[UserRead])
async def list_users(
    offset: int = 0,
    limit: int = Query(default=20, le=100),
    session: AsyncSession = Depends(get_session),
):
    statement = select(User).offset(offset).limit(limit)
    result = await session.exec(statement)
    return result.all()

@router.post("/", response_model=UserRead, status_code=status.HTTP_201_CREATED)
async def create_user(
    data: UserCreate,
    session: AsyncSession = Depends(get_session),
):
    user = User.model_validate(data)
    session.add(user)
    await session.commit()
    await session.refresh(user)
    return user
```

## 中间件

```python
from starlette.middleware.base import BaseHTTPMiddleware

class RequestIdMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        request_id = request.headers.get("X-Request-ID", str(uuid4()))
        request.state.request_id = request_id
        response = await call_next(request)
        response.headers["X-Request-ID"] = request_id
        return response

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,  # 不使用 ["*"]
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
    allow_credentials=True,
)
```

## 统一响应格式

```python
from pydantic import BaseModel
from typing import Generic, TypeVar

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    success: bool = True
    data: T | None = None
    error: dict | None = None
    metadata: dict | None = None
```

## 后台任务

```python
from fastapi import BackgroundTasks

@router.post("/send-email")
async def send_email(
    email: EmailRequest,
    background_tasks: BackgroundTasks,
):
    background_tasks.add_task(send_email_task, email.to, email.body)
    return {"message": "Email queued"}
```

## 文件上传

```python
from fastapi import UploadFile

@router.post("/upload")
async def upload_file(file: UploadFile):
    if file.size > 10 * 1024 * 1024:  # 10MB
        raise HTTPException(413, "File too large")
    content = await file.read()
    # process...
```

## 数据库会话管理

```python
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker

engine = create_async_engine(settings.database_url)
async_session_maker = async_sessionmaker(engine, class_=AsyncSession)

async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        try:
            yield session
        except Exception:
            await session.rollback()
            raise
```

## 部署

```bash
# 开发
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# 生产
gunicorn src.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```
