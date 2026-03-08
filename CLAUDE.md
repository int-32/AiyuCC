# 用户级全局配置 — AiyuCC

你是 Claude Code。我是一名全栈开发者，主要技术栈为 Python + TypeScript。
以下是我的全局开发偏好和规则，适用于所有项目。

## 核心原则

1. **Agent 优先**: 复杂任务主动委派给专业 Agent（planner, architect, code-reviewer 等）
2. **并行执行**: 独立任务使用 Task 工具并行处理，最大化效率
3. **先规划后执行**: 复杂操作先进入 Plan Mode，确认后再动手
4. **测试驱动**: 先写测试（RED），再写实现（GREEN），最后重构（REFACTOR）
5. **安全第一**: 绝不妥协安全要求，提交前必过安全检查清单

## 技术栈

| 领域 | 工具 |
|------|------|
| Python 包管理 | uv |
| Python Lint/Format | ruff |
| Python 测试 | pytest + pytest-asyncio |
| Python 框架 | FastAPI, SQLModel, Pydantic v2 |
| TypeScript 运行时/包管理 | bun |
| TypeScript Lint/Format | biome |
| TypeScript 测试 | vitest / bun test |
| TypeScript 框架 | React, Next.js |
| 数据库 | PostgreSQL, SQLite |
| 容器 | Docker, docker-compose |
| AI/MCP | Claude API, 智谱AI, MCP 协议, A2A 协议 |
| 版本控制 | git + Conventional Commits |

## 模块化规则

详细规则在 `~/.claude/rules/` 中，按需自动加载:

| 规则目录 | 加载条件 | 内容 |
|---------|---------|------|
| `common/security.md` | 始终 | 安全检查清单、密钥管理 |
| `common/coding-style.md` | 始终 | 编码风格、不可变性、文件组织 |
| `common/git-workflow.md` | git 项目 | Conventional Commits、PR 工作流 |
| `common/testing.md` | 测试文件 | TDD 工作流、80% 覆盖率 |
| `common/patterns.md` | API 文件 | API 响应格式、设计模式 |
| `python/` | *.py | uv + ruff + FastAPI + SQLModel |
| `typescript/` | *.ts/*.tsx | bun + biome + React + Next.js |

## 可用 Agents

| Agent | 模型 | 用途 |
|-------|------|------|
| planner | opus | 需求分析、实施规划、风险评估 |
| architect | opus | 系统设计、架构决策（AI/MCP 方向） |
| code-reviewer | sonnet | Python+TS 代码质量和安全审查 |
| python-reviewer | sonnet | Python 专项审查（FastAPI/SQLModel/Pydantic） |
| security-reviewer | sonnet | OWASP Top 10 安全漏洞分析 |
| tdd-guide | sonnet | TDD 工作流指导（pytest + vitest） |
| build-error-resolver | sonnet | 构建错误诊断与修复（bun + uv） |
| database-reviewer | sonnet | 数据库查询与模式审查（PostgreSQL） |
| refactor-cleaner | sonnet | 死代码检测、依赖清理 |
| mcp-developer | sonnet | MCP 服务器/客户端开发专家 |
| a2a-developer | sonnet | A2A 协议开发专家 |
| discuss-facilitator | opus | 需求讨论引导（反问机制 + 开源调研） |

## 个人偏好

### 隐私与安全
- 始终脱敏日志; 绝不粘贴密钥/token/密码/JWT
- 输出前检查是否包含敏感数据

### 代码风格
- 代码、注释、文档中**不使用 emoji**
- 偏好**不可变性** — 不要直接修改对象或数组，返回新副本
- 多个小文件优于少数大文件
- 单文件 200-400 行常规，**800 行上限**
- 函数不超过 50 行
- 嵌套不超过 4 层，使用 early return

### Git
- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, `perf:`
- 提交前先本地测试
- 小范围、聚焦的提交
- 不直接提交到 main 分支

### 测试
- TDD: 先写测试
- 最低 80% 覆盖率
- 关键流程（认证、支付、安全）需要单元 + 集成 + E2E 测试

### 语言偏好
- 规则描述、注释可以使用中文
- 代码中的变量名、函数名使用英文
- Git commit message 使用英文
- 文档可以中英文混合

## MCP 工具

已配置智谱 AI MCP 服务器:
- **web-search-prime**: 网页搜索
- **web-reader**: 网页内容抓取和阅读
- **zread**: GitHub 仓库结构和文件浏览
- **zai-mcp-server**: 图像/视频分析、UI 截图转代码

## 常用命令

| 命令 | 用途 |
|------|------|
| `/plan` | 需求分析和实施规划 |
| `/coding` | 自动执行计划: 编码→测试→提交→更新状态 |
| `/tdd` | 测试驱动开发工作流 |
| `/code-review` | 代码质量和安全审查 |
| `/build-fix` | 构建错误修复 |
| `/verify` | 综合验证（构建+类型+lint+测试+安全） |
| `/refactor-clean` | 死代码检测和清理 |
| `/python-review` | Python 专项审查 |
| `/api-design` | REST API 设计评审 |
| `/update-docs` | 文档同步更新 |
| `/discuss` | 需求讨论: 确认背景、目标、IO 示例，调研开源项目 |

## 成功标准

当以下条件满足时，视为成功:
- 所有测试通过（80%+ 覆盖率）
- 无安全漏洞
- 代码可读且可维护
- lint 和类型检查通过
- 用户需求完整满足
