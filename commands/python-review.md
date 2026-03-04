---
description: Python 专项审查。FastAPI/SQLModel/Pydantic v2 代码审查。
---

# /python-review - Python 专项审查

使用 python-reviewer agent 审查 Python 代码。

## 执行步骤

1. 识别 Python 变更文件
2. 使用 python-reviewer agent 审查:
   - FastAPI 路由和依赖注入
   - SQLModel 模型和查询
   - Pydantic v2 schema
   - 类型标注完整性
   - 异步代码正确性
3. 输出审查结果

## 用户参数

$ARGUMENTS

支持:
- 无参数: 审查所有已变更的 .py 文件
- 文件路径: 审查指定文件
