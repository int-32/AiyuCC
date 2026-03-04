#!/usr/bin/env node
// 检查已修改文件中的调试语句残留
// 在 Stop hook 中异步运行

const { execSync } = require("child_process");

try {
  // 检查是否在 git 仓库中
  execSync("git rev-parse --is-inside-work-tree", { stdio: "ignore" });
} catch {
  process.exit(0); // 不在 git 仓库中，跳过
}

try {
  // 获取已修改的文件
  const files = execSync(
    "git diff --diff-filter=ACM --name-only 2>/dev/null; " +
      "git diff --cached --diff-filter=ACM --name-only 2>/dev/null",
    { encoding: "utf8" }
  )
    .trim()
    .split("\n")
    .filter(Boolean);

  const warnings = [];

  for (const file of new Set(files)) {
    try {
      const content = require("fs").readFileSync(file, "utf8");
      const lines = content.split("\n");

      lines.forEach((line, i) => {
        const lineNum = i + 1;
        if (file.endsWith(".py") && /\bprint\(/.test(line) && !/#.*noqa/.test(line)) {
          warnings.push(`  ${file}:${lineNum} — print()`);
        }
        if (/\.(ts|tsx|js|jsx)$/.test(file) && /console\.log/.test(line)) {
          warnings.push(`  ${file}:${lineNum} — console.log`);
        }
      });
    } catch {
      // 文件可能已被删除
    }
  }

  if (warnings.length > 0) {
    process.stdout.write(
      `\n[警告] 发现调试语句残留:\n${warnings.slice(0, 10).join("\n")}\n`
    );
    if (warnings.length > 10) {
      process.stdout.write(`  ... 及其他 ${warnings.length - 10} 处\n`);
    }
  }
} catch {
  // 静默失败
}
