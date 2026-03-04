---
name: a2a-patterns
description: A2A 协议模式参考。Agent Card、Task 生命周期、流式响应、多 Agent 编排。
disable-model-invocation: true
---

# A2A 协议模式参考

## Agent Card

```json
{
  "name": "Research Agent",
  "description": "Performs web research and summarization",
  "url": "https://agent.example.com",
  "version": "1.0.0",
  "capabilities": {
    "streaming": true,
    "pushNotifications": true
  },
  "skills": [
    {
      "id": "web-research",
      "name": "Web Research",
      "description": "Search and summarize web content",
      "inputModes": ["text"],
      "outputModes": ["text"]
    }
  ],
  "authentication": {
    "schemes": ["bearer"]
  }
}
```

## Task 状态机

```
submitted -> working -> completed
                    \-> failed
         \-> input-required -> working (继续)
                            \-> canceled
```

## FastAPI 实现

```python
from fastapi import FastAPI, BackgroundTasks
from fastapi.responses import StreamingResponse

app = FastAPI()

# Agent Card
@app.get("/.well-known/agent.json")
async def agent_card():
    return {
        "name": "My Agent",
        "skills": [...],
    }

# 创建 Task
@app.post("/tasks")
async def create_task(request: TaskRequest, bg: BackgroundTasks):
    task = Task(id=str(uuid4()), status="submitted", input=request.input)
    await save_task(task)
    bg.add_task(process_task, task.id)
    return TaskResponse(id=task.id, status="submitted")

# 查询 Task
@app.get("/tasks/{task_id}")
async def get_task(task_id: str):
    task = await load_task(task_id)
    if not task:
        raise HTTPException(404)
    return TaskResponse(id=task.id, status=task.status, output=task.output)

# 流式输出
@app.get("/tasks/{task_id}/stream")
async def stream_task(task_id: str):
    async def event_generator():
        async for event in task_events(task_id):
            yield f"data: {json.dumps(event)}\n\n"
    return StreamingResponse(event_generator(), media_type="text/event-stream")
```

## Task 数据模型

```python
class TaskRequest(BaseModel):
    input: str
    skill_id: str | None = None
    metadata: dict | None = None

class TaskResponse(BaseModel):
    id: str
    status: str  # submitted | working | input-required | completed | failed | canceled
    output: str | None = None
    error: str | None = None
    metadata: dict | None = None

class TaskEvent(BaseModel):
    type: str  # status | output | error
    data: str
    timestamp: datetime
```

## 多 Agent 编排

```python
async def orchestrate(query: str) -> str:
    # 1. 发现可用 Agent
    agents = await discover_agents(capability="web-research")

    # 2. 选择最佳 Agent
    agent = select_best_agent(agents, query)

    # 3. 创建 Task
    task = await create_remote_task(agent.url, TaskRequest(input=query))

    # 4. 等待完成（轮询或 SSE）
    result = await wait_for_completion(agent.url, task.id)

    return result.output
```

## Push Notification

```python
# 注册 Webhook
@app.post("/tasks/{task_id}/notifications")
async def register_notification(task_id: str, webhook: WebhookConfig):
    await save_webhook(task_id, webhook.url)
    return {"status": "registered"}

# Task 完成时通知
async def notify_completion(task_id: str):
    webhook_url = await get_webhook(task_id)
    if webhook_url:
        async with httpx.AsyncClient() as client:
            await client.post(webhook_url, json={"task_id": task_id, "status": "completed"})
```
