---
name: mcp-development
description: MCP 协议开发参考。服务器/客户端开发、Tool/Resource/Prompt 设计、transport 选型。
disable-model-invocation: true
---

# MCP 开发参考

## Python MCP 服务器

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

server = Server("my-service")

@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="search",
            description="Search for items by keyword",
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {"type": "string", "description": "Search keyword"},
                    "limit": {"type": "integer", "default": 10},
                },
                "required": ["query"],
            },
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "search":
        results = await do_search(arguments["query"], arguments.get("limit", 10))
        return [TextContent(type="text", text=json.dumps(results))]
    raise ValueError(f"Unknown tool: {name}")

async def main():
    async with stdio_server() as (read, write):
        await server.run(read, write, server.create_initialization_options())

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

## TypeScript MCP 服务器

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server({ name: "my-service", version: "1.0.0" }, {
  capabilities: { tools: {} },
});

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [{
    name: "search",
    description: "Search for items",
    inputSchema: {
      type: "object",
      properties: { query: { type: "string" } },
      required: ["query"],
    },
  }],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "search") {
    const results = await doSearch(request.params.arguments.query);
    return { content: [{ type: "text", text: JSON.stringify(results) }] };
  }
  throw new Error(`Unknown tool: ${request.params.name}`);
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

## Transport 选型

| Transport | 场景 | 特点 |
|-----------|------|------|
| stdio | 本地工具、CLI 集成 | 简单、安全、无网络 |
| SSE | 远程服务、Web 集成 | HTTP 兼容、防火墙友好 |
| HTTP | 无状态远程服务 | RESTful、易部署 |

## Resource 设计

```python
@server.list_resources()
async def list_resources() -> list[Resource]:
    return [
        Resource(
            uri="db://users",
            name="Users Database",
            description="Access user records",
            mimeType="application/json",
        )
    ]

@server.read_resource()
async def read_resource(uri: str) -> str:
    if uri == "db://users":
        users = await fetch_users()
        return json.dumps(users)
```

## 测试

```python
# 使用 stdio transport 端到端测试
import subprocess
import json

proc = subprocess.Popen(
    ["uv", "run", "python", "-m", "my_mcp_server"],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
)

# 发送 JSON-RPC 请求
request = {"jsonrpc": "2.0", "id": 1, "method": "tools/list"}
proc.stdin.write(json.dumps(request).encode() + b"\n")
response = json.loads(proc.stdout.readline())
```

## Claude Code 集成配置

```json
{
  "mcpServers": {
    "my-service": {
      "type": "stdio",
      "command": "uv",
      "args": ["run", "python", "-m", "my_mcp_server"],
      "env": { "API_KEY": "..." }
    }
  }
}
```
