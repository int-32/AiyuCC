# AiyuCC

Python + TypeScript 全栈开发的 Claude Code 插件。提供规则、代理、命令、技能的完整开发工具链，支持从需求规划到自动编码的全流程。

## 特性

- **上下文优化**: 按需加载规则和技能，常驻上下文约 1,100 tokens（节省 70%）
- **自动化工作流**: `/plan` 规划 → `/coding` 自动编码 → `/verify` 验证 → `/commit` 提交
- **TDD 内置**: 先写测试、再写实现、测试通过后自动提交
- **任务持久化**: 计划保存到 `.claude/plans/`，跨会话可续

## 安装

```bash
# 1. 安装插件（加载 agents, commands, skills, hooks）
claude plugin install /path/to/AiyuCC

# 2. 安装全局配置（rules, CLAUDE.md, contexts）
./install.sh
```

## 卸载

```bash
./uninstall.sh
```

## 目录结构

```
AiyuCC/
├── CLAUDE.md                    # 全局指令（≤150 行）
├── install.sh                   # 安装脚本
├── uninstall.sh                 # 卸载脚本
├── .claude-plugin/plugin.json   # 插件清单
├── commands/                    # 命令（11 个）
├── agents/                      # 代理（11 个）
├── skills/                      # 技能（11 个）
├── rules/                       # 规则（13 个）
│   ├── common/                  #   通用规则
│   ├── python/                  #   Python 规则
│   └── typescript/              #   TypeScript 规则
├── contexts/                    # 上下文模式（4 个）
├── hooks/                       # Hook 配置
└── scripts/hooks/               # Hook 脚本
```

## 命令

| 命令 | 说明 |
|------|------|
| `/plan` | 需求分析、模块拆分、生成分阶段实施计划，保存到 `.claude/plans/` |
| `/coding` | 读取计划文件，逐任务执行: 编码 → 测试 → lint → 提交 → 更新状态 |
| `/tdd` | 测试驱动开发，强制 RED-GREEN-REFACTOR 循环 |
| `/code-review` | Python + TypeScript 代码质量和安全审查 |
| `/python-review` | Python 专项审查（FastAPI / SQLModel / Pydantic） |
| `/build-fix` | 构建错误诊断与修复（bun + uv） |
| `/verify` | 综合验证: 构建 → 类型检查 → lint → 测试 → 安全扫描 |
| `/refactor-clean` | 死代码检测、依赖清理 |
| `/api-design` | REST API 设计评审 |
| `/update-docs` | 文档同步更新 |
| `/commit` | Conventional Commits 格式的 git 提交 |

## 代理

| Agent | 模型 | 说明 |
|-------|------|------|
| planner | opus | 需求分析、模块拆分、实施规划、风险评估 |
| architect | opus | 系统设计、架构决策（AI/MCP 方向） |
| code-reviewer | sonnet | Python + TypeScript 代码质量和安全审查 |
| python-reviewer | sonnet | FastAPI / SQLModel / Pydantic 专项审查 |
| security-reviewer | sonnet | OWASP Top 10 安全漏洞分析 |
| tdd-guide | sonnet | TDD 工作流指导（pytest + vitest） |
| build-error-resolver | sonnet | 构建错误诊断（bun + uv） |
| database-reviewer | sonnet | PostgreSQL 查询与模式审查 |
| refactor-cleaner | sonnet | 死代码检测、依赖清理 |
| mcp-developer | sonnet | MCP 服务器/客户端开发 |
| a2a-developer | sonnet | A2A 协议开发 |

## 技能

**自动调用**（Claude 根据上下文自动激活）:

| 技能 | 说明 |
|------|------|
| tdd-workflow | TDD 完整工作流参考 |
| verification-loop | 验证循环流程 |
| coding-standards | 编码标准总览 |

**手动调用**（零上下文成本，通过 `/skill-name` 调用）:

| 技能 | 说明 |
|------|------|
| python-patterns | Python 深度模式参考 |
| typescript-patterns | TypeScript 深度模式参考 |
| fastapi-patterns | FastAPI 最佳实践 |
| api-design | API 设计参考 |
| database-patterns | PostgreSQL + SQLModel 参考 |
| docker-patterns | Docker 容器化参考 |
| mcp-development | MCP 开发参考 |
| a2a-patterns | A2A 协议参考 |

## 规则

规则通过 `paths` 字段按需加载，减少上下文占用:

| 规则 | 加载条件 | 内容 |
|------|---------|------|
| common/security | 始终 | 安全检查清单、密钥管理 |
| common/coding-style | 始终 | 编码风格、不可变性、文件组织 |
| common/git-workflow | git 项目 | Conventional Commits、PR 工作流 |
| common/testing | 测试文件 | TDD 工作流、80% 覆盖率 |
| common/patterns | API 文件 | API 响应格式、设计模式 |
| python/* | `**/*.py` | uv + ruff + FastAPI + SQLModel |
| typescript/* | `**/*.ts, **/*.tsx` | bun + biome + React + Next.js |

## 上下文模式

通过 `--system-prompt` 注入不同的工作模式:

```bash
claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"       # 开发模式
claude --system-prompt "$(cat ~/.claude/contexts/review.md)"    # 审查模式
claude --system-prompt "$(cat ~/.claude/contexts/research.md)"  # 研究模式
claude --system-prompt "$(cat ~/.claude/contexts/planning.md)"  # 规划模式
```

## Hooks

| Hook | 触发时机 | 说明 |
|------|---------|------|
| git push 提醒 | PreToolUse/Bash | push 前提醒审查变更 |
| 文档文件拦截 | PreToolUse/Write | 阻止创建多余的 .md/.txt 文件 |
| Python 格式化 | PostToolUse/Edit | 编辑 .py 后自动 ruff format + check |
| TypeScript 类型检查 | PostToolUse/Edit | 编辑 .ts 后异步 tsc 类型检查 |
| 调试语句检查 | Stop | 停止前检查 print()/console.log 残留 |

## 项目开发示例

以开发一个"用户认证系统"为例，展示完整的开发流程。

### 第 1 步: 规划

```
/plan 开发用户认证系统，支持注册、登录、JWT token，使用 FastAPI + SQLModel
```

planner agent 自动分析代码库，输出:
- 模块拆分表（auth-model, auth-routes, auth-middleware, tests）
- 分阶段实施计划（每步包含文件路径、操作、风险等级）
- 任务清单（带 checkbox，保存到 `.claude/plans/user-auth.md`）

确认计划后进入下一步。

### 第 2 步: 自动编码

```
/coding .claude/plans/user-auth.md
```

自动逐任务执行:

```
已加载计划: 用户认证系统
未完成任务: 8/8

[1/8] 阶段1: 创建 User 模型 (src/models/user.py)
  编码中... 完成 (先写 test_user.py，再写实现)
  测试中... 3/3 通过
  提交中... feat(auth): add User model with password hashing
  状态已更新

[2/8] 阶段1: 创建认证 schema (src/schemas/auth.py)
  编码中... 完成
  测试中... 4/4 通过
  提交中... feat(auth): add login and register schemas
  状态已更新

[3/8] 阶段2: 实现注册接口 (src/routes/auth.py)
  编码中... 完成
  测试中... 2/5 失败 (邮箱验证格式)
  修复中... 第 2 次测试 5/5 通过
  提交中... feat(auth): add register endpoint
  状态已更新

...
```

如果上下文用完，开新会话继续:

```
/coding .claude/plans/user-auth.md
```

自动从 `- [ ]` 未完成任务继续，已完成的 `- [x]` 跳过。

### 第 3 步: 审查

```
/code-review        # 通用代码审查
/python-review      # FastAPI/SQLModel 专项审查
/verify             # 构建 + 类型 + lint + 测试 + 安全 全面验证
```

### 第 4 步: 提交

```
/commit
```

### 按需查阅参考资料

开发过程中随时调用手动技能获取深度参考:

```
/fastapi-patterns    # FastAPI 最佳实践
/database-patterns   # SQLModel 查询模式
/python-patterns     # Python 设计模式
```

这些技能平时不占上下文，调用时按需加载。

## 技术栈

| 领域 | 工具 |
|------|------|
| Python | uv, ruff, pytest, FastAPI, SQLModel, Pydantic v2 |
| TypeScript | bun, biome, vitest, React, Next.js |
| 数据库 | PostgreSQL, SQLite |
| 容器 | Docker, docker-compose |
| AI/MCP | Claude API, MCP 协议, A2A 协议 |
| 版本控制 | git + Conventional Commits |

## License

MIT
