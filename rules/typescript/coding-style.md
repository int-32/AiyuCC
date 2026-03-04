---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "**/package.json"
  - "**/tsconfig.json"
---

# TypeScript 编码风格

## 工具链

- 运行时 + 包管理: **bun** (不使用 npm/pnpm/yarn)
- Lint + Format: **biome** (不使用 eslint/prettier)
- 类型检查: tsc --noEmit

## 类型安全

- 启用 `strict: true`
- 禁止 `any` — 使用 `unknown` + type guard
- 使用 `as const` 确保字面量类型
- 优先使用 `interface` 定义对象形状，`type` 用于联合/交叉

## 不可变性

- 使用 `const` 声明（不使用 `let`，禁止 `var`）
- 使用 `readonly` 修饰符
- 使用 spread 创建新对象/数组: `{ ...obj, key: value }`
- 数组操作使用 `map/filter/reduce` 而非 `push/splice`

## 异步

- 使用 async/await（不使用 .then 链）
- 错误处理: try-catch 包裹 await
- 并行: `Promise.all()` / `Promise.allSettled()`

## 验证

- 运行时验证使用 **Zod**
- 从 Zod schema 推导 TypeScript 类型: `z.infer<typeof schema>`

## 禁止

- 不使用 `console.log`（开发调试后删除）
- 不使用 `// @ts-ignore`（修复类型问题而非忽略）
- 不使用 `enum`（使用 `as const` 对象替代）
