import asyncio
from fastmcp import Client
from dotenv import load_dotenv  # pip install python-dotenv
import os, time

load_dotenv()

MCP_SERVER=os.getenv("MCP_SERVER")
client = Client(MCP_SERVER)
print(f"{MCP_SERVER=}")

async def call_tool(name: str):
    async with client:
        result = await client.call_tool("greet", {"name": name})
        print(result.data)

while True:
    asyncio.run(call_tool("Emmanuel"))
    time.sleep(30)