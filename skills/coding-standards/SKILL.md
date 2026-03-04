---
name: coding-standards
description: 编码标准总览。Python 和 TypeScript 编码规范快速参考。
---

# 编码标准

## 通用原则

- 不可变性优先: 返回新副本，不就地修改
- 文件 200-400 行常规，800 行上限
- 函数不超过 50 行，嵌套不超过 4 层
- 使用 early return 减少嵌套
- 代码自解释，注释说明 "为什么"

## Python 标准

| 项目 | 标准 |
|------|------|
| 包管理 | uv |
| Lint/Format | ruff |
| 类型标注 | 必须（所有函数签名） |
| 异步 | async/await (I/O 操作) |
| 验证 | Pydantic v2 |
| ORM | SQLModel |
| 测试 | pytest + pytest-asyncio |

## TypeScript 标准

| 项目 | 标准 |
|------|------|
| 运行时 | bun |
| Lint/Format | biome |
| 类型 | strict: true, 禁止 any |
| 验证 | Zod |
| 框架 | React + Next.js (App Router) |
| 测试 | vitest / bun test |

## 禁止清单

- 硬编码密钥
- console.log / print() 残留
- 空的 catch/except
- `any` 类型
- `var` 声明
- `// @ts-ignore`
- `from module import *`
