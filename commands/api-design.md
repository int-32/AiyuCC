---
description: REST API 设计评审。评审 API 端点设计、请求/响应格式和错误处理。
---

# /api-design - API 设计评审

评审和改进 REST API 设计。

## 评审维度

1. **URL 设计** — RESTful 命名、资源层级
2. **HTTP 方法** — GET/POST/PUT/PATCH/DELETE 正确使用
3. **请求/响应格式** — 统一的响应信封、分页、过滤
4. **错误处理** — 错误码规范、错误信息格式
5. **版本策略** — URL 版本 vs Header 版本
6. **认证/授权** — 端点保护策略

## 用户参数

$ARGUMENTS

支持:
- 无参数: 扫描项目中的路由定义并评审
- API 描述: 评审描述的 API 设计方案
