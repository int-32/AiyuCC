---
paths:
  - "**/*.test.ts"
  - "**/*.spec.ts"
  - "**/*.test.tsx"
  - "**/*.spec.tsx"
  - "**/__tests__/**"
  - "**/vitest.config.*"
  - "**/playwright.config.*"
---

# TypeScript 测试规范

## 工具

- 单元/集成: **vitest** 或 **bun test**
- React 组件: @testing-library/react
- E2E: Playwright
- Mock: vitest 内置 mock

## 单元测试

```typescript
import { describe, it, expect } from "vitest";

describe("calculateTotal", () => {
  it("should return sum of item prices", () => {
    const items = [{ price: 10 }, { price: 20 }];
    expect(calculateTotal(items)).toBe(30);
  });

  it("should return 0 for empty array", () => {
    expect(calculateTotal([])).toBe(0);
  });
});
```

## React 组件测试

- 测试用户行为而非实现细节
- 使用 `screen.getByRole()` 而非 `getByTestId()`
- 使用 `userEvent` 而非 `fireEvent`

## E2E 测试

- 使用语义化选择器 (role, label, text)
- 每个测试独立（不依赖其他测试的状态）
- Page Object 模式组织复杂页面

## 命名

- 文件: `<module>.test.ts` 或 `<module>.spec.ts`
- 描述: `should <expected> when <condition>`
