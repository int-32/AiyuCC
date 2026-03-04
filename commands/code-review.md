---
description: 代码质量和安全审查。检查代码变更的安全性、正确性和可维护性。
---

# /code-review - 代码审查

使用 code-reviewer agent 审查代码变更。

## 执行步骤

1. 运行 `git diff` 和 `git diff --cached` 查看所有变更
2. 使用 code-reviewer agent 逐文件审查
3. 按严重性 (CRITICAL > HIGH > MEDIUM > LOW) 排序输出结果
4. 检查相关测试是否覆盖变更

## 用户参数

$ARGUMENTS

支持的参数:
- 无参数: 审查所有未提交的变更
- 文件路径: 审查指定文件
- PR 编号: 审查指定 PR 的变更
