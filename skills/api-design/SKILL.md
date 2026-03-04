---
name: api-design
description: REST API 设计参考。URL 设计、HTTP 方法、分页、过滤、错误码规范。
disable-model-invocation: true
---

# API 设计参考

## URL 设计

```
GET    /api/v1/users          # 列表
POST   /api/v1/users          # 创建
GET    /api/v1/users/{id}     # 获取
PUT    /api/v1/users/{id}     # 全量更新
PATCH  /api/v1/users/{id}     # 部分更新
DELETE /api/v1/users/{id}     # 删除

GET    /api/v1/users/{id}/orders  # 嵌套资源
POST   /api/v1/users/{id}/orders
```

- 资源名使用复数名词
- URL 层级不超过 3 层
- 使用连字符 `-` 分隔多词: `/api/v1/user-profiles`

## 分页

```json
GET /api/v1/users?offset=0&limit=20

{
  "success": true,
  "data": [...],
  "metadata": {
    "total": 100,
    "offset": 0,
    "limit": 20,
    "has_more": true
  }
}
```

## 过滤和排序

```
GET /api/v1/users?status=active&sort=-created_at&fields=id,name,email
```

## HTTP 状态码

| 码 | 用途 |
|----|------|
| 200 | 成功 (GET/PUT/PATCH) |
| 201 | 创建成功 (POST) |
| 204 | 删除成功 (DELETE) |
| 400 | 请求无效 |
| 401 | 未认证 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 409 | 冲突 |
| 422 | 验证失败 |
| 429 | 请求过多 |
| 500 | 服务器内部错误 |

## 错误响应格式

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email format is invalid",
    "details": [
      {"field": "email", "message": "Must be a valid email address"}
    ]
  }
}
```

## 版本策略

推荐 URL 版本: `/api/v1/`, `/api/v2/`
- 简单直观，易于路由
- 可同时运行多版本
