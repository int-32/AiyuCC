---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript 模式规范

## React 模式

- 函数组件 + Hooks（不使用 class 组件）
- 组件拆分: Container (数据) / Presentational (UI)
- 自定义 Hook 提取可复用逻辑: `useXxx()`
- Props 使用 interface 定义，必须有类型
- 避免 prop drilling — 使用 Context 或状态管理

## Next.js 模式

- App Router (不使用 Pages Router)
- Server Component 优先，仅必要时添加 `"use client"`
- 数据获取在 Server Component 中完成
- Loading/Error 使用 `loading.tsx` / `error.tsx`
- 使用 Server Actions 处理表单

## 状态管理

- 本地状态: `useState` / `useReducer`
- 服务端状态: TanStack Query (React Query)
- 全局状态: Zustand（轻量）或 Context

## API 模式

- 请求/响应类型与 Zod schema 对应
- API 客户端封装统一的错误处理
- 使用 `fetch` 或 `ky` (不使用 axios)

## 错误边界

- 关键 UI 区域包裹 ErrorBoundary
- 使用 `error.tsx` 处理路由级错误
