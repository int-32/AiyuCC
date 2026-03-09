---
description: 需求分析和实施规划。重述需求、分析代码库、拆分模块、设计接口、创建分层计划文档（总体架构 + 模块独立文档）。
---

# /plan - 实施规划

使用 planner agent 创建分层实施计划，生成总体架构文档和各模块独立计划文档。

## 执行步骤

1. **重述需求** — 用自己的话重述用户需求，确认理解正确
2. **分析代码库** — 使用 Glob/Grep/Read 了解相关代码结构
3. **模块拆分** — 将需求拆解为独立模块/组件，明确边界
4. **接口设计** — 提取每个模块的对外接口和依赖接口
5. **创建分层计划** — 总体架构 + 各模块独立文档，含 Wave 并行调度
6. **注册任务** — 用 TodoWrite 将各模块的任务汇总注册为可追踪的清单
7. **等待确认** — 不要在用户确认前写任何代码

## 用户参数

$ARGUMENTS

如果用户未提供参数，询问要规划的功能。

## 调用 Agent

使用 Task 工具调用 planner agent:
- subagent_type: Plan
- 提供完整的上下文和需求描述
- model: opus

## 后续步骤

planner agent 返回计划后:

### 1. 解析多文档输出

Agent 输出中用 `===FILE: <filename>===` 标记分隔不同文件。解析并提取:
- `_overview.md` — 总体架构文档
- `<module-name>.md` — 各模块独立文档

### 2. 创建计划目录

创建 `.claude/plans/<plan-name>/` 目录，将解析出的文件逐个写入:
- `.claude/plans/<plan-name>/_overview.md`
- `.claude/plans/<plan-name>/module-a.md`
- `.claude/plans/<plan-name>/module-b.md`
- ...

### 3. 提取并注册任务清单

从 `_overview.md` 的「全局任务清单」中提取所有步骤，注册 TodoWrite:
- content: "Wave2: 步骤描述 (文件路径) [模块: module-b] [⚡并行-A]"
- activeForm: "正在执行: 步骤描述"
- status: pending

### 4. 展示给用户

按以下顺序展示:
1. **总体架构** — 概述、模块拆分表、接口依赖图、并行依赖图
2. **Agent Team 调度表** — 全局的 Wave/Agent/并行组分配
3. **各模块概要** — 每个模块的职责 + 对外接口 + 依赖接口（摘要）
4. 提示用户: "详细模块文档已保存至 `.claude/plans/<plan-name>/`，可用 `/coding` 执行"

等待用户确认后再进入执行阶段。

### 5. 按 Wave 执行

确认后按 Wave 顺序执行:
- **串行 Wave**: 按顺序逐步执行
- **并行 Wave**: 通过 Task 工具同时启动多个 Agent 并行执行同一 Wave 内的所有任务
- 每个 Wave 全部完成后，运行受影响的测试做集成验证
- 验证通过后再进入下一个 Wave
- 每完成一步，标记 TodoWrite 为 completed，同步更新对应模块文件 `- [ ]` → `- [x]`

## Agent Team 并行执行说明

当 Wave 标记为"⚡并行执行"时:
- 使用 Task 工具为该 Wave 中的每个任务创建独立的子任务
- 每个子任务分配给 Agent Team 调度表中指定的 Agent
- 各 Agent 在独立上下文中并行工作，互不干扰
- 等待所有并行任务完成后，统一验证再进入下一 Wave

## 持久化说明

- 计划文件保存在项目的 `.claude/plans/<plan-name>/` **目录**下
- 目录名基于功能名称，如 `.claude/plans/user-auth/`
- 目录内包含 `_overview.md`（总体架构）和各模块独立文档
- 每完成一个任务，用 Edit 工具更新**对应模块文件**中的 `- [ ]` → `- [x]`
- 同时更新 `_overview.md` 中全局任务清单的状态
- 新会话读取计划时，先读 `_overview.md` 获取全局进度和模块索引，再按需读取模块文档
