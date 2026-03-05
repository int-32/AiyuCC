---
description: 自动编码执行。读取计划文件，找到未完成任务，逐个编码、测试、提交、更新状态。
---

# /coding - 自动编码执行

读取计划文件中的未完成任务，自动执行编码 → 测试 → 提交 → 更新状态的循环。

## 用户参数

$ARGUMENTS

支持:
- 计划文件路径，如 `/coding .claude/plans/user-auth.md`
- 无参数时，自动扫描 `.claude/plans/` 目录，列出含未完成任务的计划供选择

## 执行流程

### 1. 加载计划

- 读取指定的计划文件（或扫描 `.claude/plans/*.md`）
- 解析任务清单，找到所有 `- [ ]` 未完成任务
- 跳过已完成的 `- [x]` 任务
- 如果没有未完成任务，提示用户并退出

### 2. 注册 TodoWrite

将所有未完成任务注册到 TodoWrite:
- 已完成的标记为 completed
- 未完成的标记为 pending
- 第一个未完成任务标记为 in_progress

### 3. 逐任务执行循环

对每个未完成任务，执行以下循环:

#### a. 编码 + 测试 (Code + Test — TDD)

使用 `/tdd` 命令的 TDD 工作流，对每个任务执行严格的 **RED → GREEN → REFACTOR** 循环:

1. **理解需求** — 读取任务描述中的模块、文件路径、操作说明，阅读相关代码理解上下文
2. **RED** — 根据任务要求，先写一个失败的测试
3. **运行测试** — 确认测试失败（且失败原因正确）
4. **GREEN** — 写最少代码让测试通过
5. **运行测试** — 确认通过
6. **REFACTOR** — 在测试保护下重构代码
7. **重复** — 如果任务需要多个测试用例，继续下一轮 RED-GREEN-REFACTOR

**测试工具**:
- Python: `uv run pytest <test_file> -v`
- TypeScript: `bun test <test_file>` / `bunx vitest run <test_file>`

**前端视觉验证**（涉及 UI 组件时额外执行）:
- 判断条件: 任务文件路径匹配 `**/components/**`, `**/pages/**`, `**/app/**`, `**/*.tsx`
- 启动 dev server（使用 preview_start 工具）
- 用 preview_screenshot 截图检查页面渲染
- 用 preview_snapshot 获取可访问性树，验证元素存在和文本内容
- 用 preview_inspect 检查关键样式（颜色、间距、布局）
- 检查 preview_console_logs 确认无运行时错误
- 检查 preview_network（filter: failed）确认无失败请求

**测试失败处理**:
- 分析失败原因
- 修复代码（回到 GREEN 步骤）
- 重新测试（最多 3 次）
- 如果 3 次后仍失败，**暂停并询问用户**

#### b. 质量检查 (Lint)
- Python: `uv run ruff check --fix <file> && uv run ruff format <file>`
- TypeScript: `bunx biome check --fix <file>`

#### c. 提交 (Commit)
- `git add <修改的文件>`
- 生成 Conventional Commit 消息:
  - 类型根据任务自动判断 (feat/fix/refactor/test)
  - scope 使用模块名
  - 描述使用任务摘要
- `git commit` (不加 --no-verify，让 hooks 运行)

#### d. 更新状态 (Update)
- TodoWrite: 标记当前任务为 completed
- 计划文件: `- [ ]` → `- [x]`（用 Edit 工具更新）
- 下一个任务标记为 in_progress

### 4. 完成报告

所有任务完成后，输出摘要:
- 完成的任务数量
- 创建的 commit 列表（`git log --oneline`）
- 测试覆盖率（如可用）
- 是否有跳过或失败的任务

## 错误处理

| 场景 | 处理 |
|------|------|
| 测试失败 3 次 | 暂停，询问用户是否跳过或手动修复 |
| commit 被 hook 拒绝 | 修复 hook 报告的问题，重新提交 |
| 文件冲突 | 暂停，展示冲突内容，询问用户 |
| 计划文件不存在 | 提示运行 `/plan` 先创建计划 |

## 安全规则

- 每个 commit 前自动检查: 不提交密钥、token、密码
- 不直接提交到 main/master 分支
- 每个 commit 范围小且聚焦，便于 review

## 示例

```
/coding .claude/plans/user-auth.md
```

输出:
```
已加载计划: 用户认证系统
未完成任务: 5/8

[1/5] 阶段2: 创建 User 模型 (src/models/user.py)
  编码中... 完成
  测试中... 3/3 通过
  提交中... feat(auth): add User model with password hashing
  状态已更新

[2/5] 阶段2: 创建认证路由 (src/routes/auth.py)
  编码中... 完成
  测试中... 5/5 通过
  提交中... feat(auth): add login and register endpoints
  状态已更新

...

完成! 5/5 任务已完成
Commits:
  abc1234 feat(auth): add User model with password hashing
  def5678 feat(auth): add login and register endpoints
  ...
```
