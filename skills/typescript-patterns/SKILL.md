---
name: typescript-patterns
description: TypeScript 深度模式参考。bun + React + Next.js + Zod 最佳实践。
disable-model-invocation: true
---

# TypeScript 模式参考

## Zod 验证

```typescript
import { z } from "zod";

const UserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
});

type User = z.infer<typeof UserSchema>;

// 运行时验证
const result = UserSchema.safeParse(input);
if (!result.success) {
  console.error(result.error.flatten());
}
```

## React Hooks 模式

```typescript
// 自定义 Hook
function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const controller = new AbortController();
    fetchUser(id, { signal: controller.signal })
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
    return () => controller.abort();
  }, [id]);

  return { user, loading, error };
}
```

## Next.js App Router

```typescript
// app/users/page.tsx - Server Component (default)
export default async function UsersPage() {
  const users = await fetchUsers(); // 直接在服务端获取数据
  return <UserList users={users} />;
}

// app/users/loading.tsx
export default function Loading() {
  return <Skeleton />;
}

// app/users/error.tsx
"use client";
export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return <ErrorDisplay error={error} onRetry={reset} />;
}
```

## Server Actions

```typescript
// app/actions.ts
"use server";

import { revalidatePath } from "next/cache";

export async function createUser(formData: FormData) {
  const data = UserSchema.parse({
    name: formData.get("name"),
    email: formData.get("email"),
  });
  await db.user.create({ data });
  revalidatePath("/users");
}
```

## API 客户端

```typescript
class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  async request<T>(path: string, options?: RequestInit): Promise<T> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      ...options,
      headers: {
        "Content-Type": "application/json",
        ...options?.headers,
      },
    });
    if (!response.ok) {
      throw new ApiError(response.status, await response.text());
    }
    return response.json();
  }
}
```

## 状态管理 (Zustand)

```typescript
import { create } from "zustand";

interface AuthStore {
  user: User | null;
  login: (credentials: Credentials) => Promise<void>;
  logout: () => void;
}

const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  login: async (credentials) => {
    const user = await api.login(credentials);
    set({ user });
  },
  logout: () => set({ user: null }),
}));
```

## 环境变量验证

```typescript
const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  NEXT_PUBLIC_API_URL: z.string().url(),
  SECRET_KEY: z.string().min(32),
});

export const env = envSchema.parse(process.env);
```
