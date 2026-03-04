#!/usr/bin/env node
// 策略性压缩提示
// 跟踪 Edit/Write 工具调用次数，达到阈值时建议 /compact

const fs = require("fs");
const path = require("path");

const THRESHOLD = 50;
const REMIND_INTERVAL = 25;
const STATE_FILE = path.join(
  process.env.HOME || "",
  ".claude",
  ".compact-state.json"
);

function loadState() {
  try {
    return JSON.parse(fs.readFileSync(STATE_FILE, "utf8"));
  } catch {
    return { count: 0, lastRemind: 0 };
  }
}

function saveState(state) {
  try {
    fs.writeFileSync(STATE_FILE, JSON.stringify(state));
  } catch {
    // ignore write errors
  }
}

const state = loadState();
state.count += 1;

if (
  state.count >= THRESHOLD &&
  state.count - state.lastRemind >= REMIND_INTERVAL
) {
  state.lastRemind = state.count;
  process.stdout.write(
    `\n[提示] 已执行 ${state.count} 次编辑操作。` +
      `建议在合适的逻辑断点执行 /compact 压缩上下文。\n`
  );
}

saveState(state);
