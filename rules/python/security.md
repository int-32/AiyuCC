---
paths:
  - "**/*.py"
---

# Python 安全规范

## 依赖安全

- 使用 `uv audit` 检查已知漏洞
- 锁定依赖版本（uv.lock）
- 定期更新依赖

## FastAPI 安全

- CORS: 生产环境严格限制 `allow_origins`，不使用 `["*"]`
- 认证: 使用 OAuth2 + JWT，通过 `Depends()` 注入
- 输入验证: 所有请求体通过 Pydantic schema 验证
- 速率限制: 使用 slowapi 或中间件实现

## 数据库安全

- 始终使用 SQLModel/SQLAlchemy 的参数化查询
- 禁止字符串拼接 SQL
- 敏感字段（密码）使用 bcrypt/argon2 哈希
- 数据库凭证通过环境变量配置

## 密钥管理

- 使用 pydantic-settings 从环境变量加载配置
- `.env` 文件加入 `.gitignore`
- 绝不在代码中硬编码密钥

## 日志安全

- 日志中脱敏处理敏感数据（密码、token、个人信息）
- 不在 DEBUG 级别输出请求体中的密码字段
