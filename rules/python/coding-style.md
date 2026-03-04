---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python 编码风格

## 工具链

- 包管理: **uv** (不使用 pip/poetry/pipenv)
- Lint + Format: **ruff** (不使用 black/isort/flake8)
- 类型检查: pyright / mypy

## 类型标注

- 所有函数签名必须有类型标注（参数 + 返回值）
- 使用 `from __future__ import annotations` 延迟求值
- 优先使用内置泛型: `list[str]`, `dict[str, int]`, `str | None`

## 不可变性

- 使用 `@dataclass(frozen=True)` 或 `NamedTuple`
- DTO 使用 Pydantic `BaseModel`（默认不可变）
- 避免全局可变状态

## 异步

- I/O 操作使用 async/await
- 使用 `asyncio.gather()` 并行执行独立 I/O
- 避免在 async 函数中调用同步阻塞代码

## 导入

- ruff 管理导入排序
- 标准库 → 第三方 → 本地 三组排列
- 避免 `from module import *`

## 项目结构

```
src/
  package_name/
    __init__.py
    main.py           # FastAPI app 入口
    models/            # SQLModel / Pydantic models
    schemas/           # Pydantic v2 request/response schemas
    routers/           # FastAPI routers
    services/          # 业务逻辑
    repositories/      # 数据访问层
    utils/             # 工具函数
    config.py          # pydantic-settings 配置
tests/
  conftest.py
  test_*.py
```
