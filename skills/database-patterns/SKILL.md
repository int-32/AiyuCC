---
name: database-patterns
description: 数据库模式参考。PostgreSQL + SQLModel 查询优化、迁移、索引策略。
disable-model-invocation: true
---

# 数据库模式参考

## SQLModel 查询模式

```python
# 基础查询
statement = select(User).where(User.email == email)
result = await session.exec(statement)
user = result.first()

# 分页
statement = select(User).offset(offset).limit(limit).order_by(User.created_at.desc())

# 关联查询
statement = (
    select(User, Order)
    .join(Order, User.id == Order.user_id)
    .where(Order.status == "active")
)

# 聚合
from sqlalchemy import func
statement = select(func.count(User.id)).where(User.active == True)
count = (await session.exec(statement)).one()
```

## 索引策略

```python
class User(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True)       # 唯一索引
    name: str = Field(index=True)                       # 普通索引
    status: str = Field(index=True)
    created_at: datetime = Field(default_factory=datetime.utcnow, index=True)
```

何时加索引:
- WHERE 条件频繁使用的字段
- JOIN 条件字段
- ORDER BY 字段
- UNIQUE 约束字段

## 迁移 (Alembic)

```bash
# 初始化
alembic init alembic

# 创建迁移
alembic revision --autogenerate -m "add users table"

# 执行迁移
alembic upgrade head

# 回滚
alembic downgrade -1
```

迁移安全原则:
- 大表 ALTER 使用 `op.execute` 分批处理
- 添加列用 `server_default` 避免锁表
- 删除列前先确认无引用
- 迁移必须可回滚

## 事务管理

```python
async def transfer_funds(from_id: int, to_id: int, amount: Decimal):
    async with async_session_maker() as session:
        async with session.begin():  # 自动 commit/rollback
            sender = await session.get(Account, from_id, with_for_update=True)
            receiver = await session.get(Account, to_id, with_for_update=True)
            if sender.balance < amount:
                raise InsufficientFunds()
            sender.balance -= amount
            receiver.balance += amount
```

## N+1 查询解决

```python
# 问题: N+1
users = await session.exec(select(User))
for user in users:
    orders = await session.exec(select(Order).where(Order.user_id == user.id))

# 解决: JOIN + selectinload
from sqlalchemy.orm import selectinload
statement = select(User).options(selectinload(User.orders))
```

## 连接池

```python
engine = create_async_engine(
    database_url,
    pool_size=20,           # 连接池大小
    max_overflow=10,        # 额外连接数
    pool_timeout=30,        # 获取连接超时
    pool_recycle=1800,      # 连接回收时间
)
```
