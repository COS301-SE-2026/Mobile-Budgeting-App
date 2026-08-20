import os


from dotenv import load_dotenv
from fastapi import FastAPI
from database import init_db

load_dotenv()

app = FastAPI(
    title=os.getenv("APP_TITLE", "Budgetit API"),
    version=os.getenv("APP_VERSION", "0.1.0"),
)


@app.get("/health")
def health():
    return {"status": "ok"}



@app.on_event("startup")
async def on_startup():
    await init_db()