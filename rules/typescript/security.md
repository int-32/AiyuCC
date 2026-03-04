---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript 安全规范

## XSS 防护

- 使用 React JSX 自动转义（不使用 `dangerouslySetInnerHTML`）
- 用户输入展示使用 `textContent` 而非 `innerHTML`
- URL 参数需要验证和编码

## 环境变量

- 客户端环境变量使用 `NEXT_PUBLIC_` 前缀
- 敏感配置（API keys）仅在服务端使用
- `.env.local` 加入 `.gitignore`
- 使用 Zod 验证环境变量类型

## 认证

- JWT token 存储在 httpOnly cookie（不使用 localStorage）
- 实现 token 刷新机制
- 保护的 API 路由检查认证状态

## 依赖安全

- `bun audit` 检查已知漏洞
- 锁定依赖版本（bun.lock）
- 谨慎评估第三方包的安全性
