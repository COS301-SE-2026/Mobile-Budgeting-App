from email.header import Header
import os


from dotenv import load_dotenv
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy import delete as sa_delete

from database import get_db
from models import Budget, Expense
from schemas import UploadPayload, CrudOp
import jwt
from jwt import PyJWKClient

load_dotenv()

app = FastAPI(
    title=os.getenv("APP_TITLE", "Budgetit API"),
    version=os.getenv("APP_VERSION", "0.1.0"),
)

tables = {
    "users": User,
    "budgets": Budget,
    "transactions": Transaction,
    "categories": Category,
    "accounts": Account,
    "budget_categories": BudgetCategory,
    "budget_accounts": BudgetAccount,
}

@app.get("/health")
def health():
    return {"status": "ok"}



@app.on_event("startup")
async def on_startup():
    await init_db()
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all) 
    #TODO checkout alembic migration for prod

COGNITO_JWKS_URL = "https://cognito-idp.<region>.amazonaws.com/<user_pool_id>/.well-known/jwks.json"
jwks_client = PyJWKClient(COGNITO_JWKS_URL)

async def get_current_user(authorization: str = Header(...)) -> str:
    token = authorization.replace("Bearer ", "")
    try:
        signing_key = jwks_client.get_signing_key_from_jwt(token)
        payload = jwt.decode(
            token,
            signing_key.key,
            algorithms=["RS256"],
            audience="<your-cognito-app-client-id>",
        )
        return payload["sub"]  
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

def forbidden(table: str, id: str, action: str) -> HTTPException:
    return HTTPException(
        status_code=403,
        detail=f"User is not authorized to {action} {table} with id {id}",
    )

async def apply_put(db: AsyncSession, model,  entry: CrudOp, id: str, table: str,):
    values = {**entry.data, "id": entry.id}
    if table in tables:
        values["user_id"] = id
    statment = pg_insert(model).values(**values).on_conflict_do_update(
        index_elements=["id"],
        set = {i:j for i,j in values.items() if i != "id"}
    )
    await db.execute(statement)


@app.post("/powersync/upload", tags=["PowerSync"], summary="Upload CRUD queue to PowerSync", responses={200: {"description": "Upload successful"}, 400: {"description": "Problem with syntax "}, 401: {"description": "Unauthorized"}, 500: {"description": "Internal server error"}})
async def upload(payload: UploadPayload, db: AsyncSession = Depends(get_db), jwt: str = Depends(get_current_user)):
    try:
        pass
    except Exception as e:
        pass

