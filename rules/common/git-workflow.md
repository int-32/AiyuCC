---
paths:
  - "**/.gitignore"
  - "**/.git/**"
  - "**/CHANGELOG*"
---

# Git 工作流规范

## Conventional Commits

提交信息格式: `type(scope): description`

| 类型 | 用途 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 Bug |
| `refactor` | 重构（不改变功能） |
| `docs` | 文档 |
| `test` | 测试 |
| `chore` | 构建/工具/依赖 |
| `perf` | 性能优化 |
| `ci` | CI/CD 配置 |

## 规则

- Commit message 使用英文
- 提交前先本地测试通过
- 小范围、聚焦的提交（一个提交做一件事）
- 不直接提交到 main/master 分支
- PR 必须通过代码审查

## PR 工作流

1. 创建功能分支: `feat/feature-name` 或 `fix/bug-name`
2. 开发并提交（小步提交）
3. 推送并创建 PR
4. 代码审查通过后合并
