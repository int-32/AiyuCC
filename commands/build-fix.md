---
description: 构建错误修复。诊断和增量修复 bun/uv/tsc/ruff 构建错误。
---

# /build-fix - 构建错误修复

使用 build-error-resolver agent 诊断和修复构建失败。

## 执行步骤

1. 运行构建命令，捕获完整错误输出
2. 使用 build-error-resolver agent 分析错误
3. 从第一个错误开始，增量修复
4. 每次修复后重新运行构建验证

## 用户参数

$ARGUMENTS

支持的参数:
- 无参数: 自动检测项目类型并运行构建
- 错误信息: 直接分析提供的错误信息
