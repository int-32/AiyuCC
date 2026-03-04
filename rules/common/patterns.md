---
paths:
  - "**/api/**"
  - "**/routes/**"
  - "**/routers/**"
  - "**/endpoints/**"
  - "**/handlers/**"
---

# API 与设计模式

## API 响应格式

所有 API 端点使用统一的响应信封:

```json
{
  "success": true,
  "data": {},
  "error": null,
  "metadata": {
    "timestamp": "ISO-8601",
    "request_id": "uuid"
  }
}
```

错误响应:
```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "用户可读的错误描述",
    "details": []
  }
}
```

## Repository 模式

数据访问层使用 Repository 模式:
- 定义抽象接口（Protocol/Interface）
- 实现具体 Repository（SQLModel/Prisma）
- 通过依赖注入使用，便于测试 Mock

## 输入验证

- 系统边界处验证（用户输入、外部 API）
- Python: Pydantic v2 BaseModel
- TypeScript: Zod schema
- 内部层之间信任类型系统
