from fastmcp import FastMCP
from dotenv import load_dotenv  # pip install python-dotenv
import os, random

load_dotenv()

NAME = os.getenv("APP_NAME", "NOTHING")
NO = random.randrange(9999999999)

mcp = FastMCP("My MCP Server")

@mcp.tool
def greet(name: str) -> str:
    return f"Hello, {name} ! [{NAME}-{NO}]"

if __name__ == "__main__":
    mcp.run(transport="http", port=8000)