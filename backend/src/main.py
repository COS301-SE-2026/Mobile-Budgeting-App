import os
from typing import Annotated

from dotenv import load_dotenv
from fastapi import FastAPI, Depends, HTTPException, Header
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy import delete as sa_delete

from database import get_db, engine, Base, init_db
from models import (
    Category,
    CategoryClosure,
    Transaction,
    TransactionCategoryMap,
    BudgetTemplate,
    BudgetPeriod,
    RecurringTransaction,
    Import,
)
from schema import UploadPayload, CrudOp
import jwt
from jwt import PyJWKClient

load_dotenv()

app = FastAPI(
    title=os.getenv("APP_TITLE", "Budgetit API"),
    version=os.getenv("APP_VERSION", "0.1.0"),
)

tables = {
    "categories": Category,
    "category_closure": CategoryClosure,
    "transactions": Transaction,
    "transaction_category_map": TransactionCategoryMap,
    "budget_templates": BudgetTemplate,
    "budget_periods": BudgetPeriod,
    "recurring_transactions": RecurringTransaction,
    "imports": Import,
}

OWNED_TABLES = {
    "categories",
    "transactions",
    "budget_templates",
    "recurring_transactions",
    "imports",
}

JOIN_OWNED_TABLES = {
    "category_closure": (Category, "descendant_id"),
    "transaction_category_map": (Transaction, "transaction_id"),
    "budget_periods": (BudgetTemplate, "template_id"),
}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.on_event("startup")
async def on_startup():
    await init_db()
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


COGNITO_JWKS_URL = "https://cognito-idp.<region>.amazonaws.com/<user_pool_id>/.well-known/jwks.json"
jwks_client = PyJWKClient(COGNITO_JWKS_URL)


async def get_current_user(authorization: Annotated[str, Header(...)]) -> str:
    token = authorization.replace("Bearer ", "")
    try:
        signing_key = jwks_client.get_signing_key_from_jwt(token)
        payload = jwt.decode(
            token,
            signing_key.key,
            algorithms=["RS256"],
            audience="",
        )
        return payload["sub"]
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")


def forbidden(table: str, entry_id: str, action: str) -> HTTPException:
    return HTTPException(
        status_code=403,
        detail=f"User is not authorized to {action} {table} with id {entry_id}",
    )


async def join_owner_id(db: AsyncSession, table: str, parent_ref_id: str) -> str | None:
    parent_model, _ = JOIN_OWNED_TABLES[table]
    parent = await db.get(parent_model, parent_ref_id)
    return getattr(parent, "user_id", None) if parent else None


async def check_join_ownership_for_write(
    db: AsyncSession, entry: CrudOp, user_id: str, table: str
) -> None:
    parent_model, ref_column = JOIN_OWNED_TABLES[table]
    parent_ref_id = entry.data.get(ref_column)
    if parent_ref_id is None:
        raise HTTPException(
            status_code=400, detail=f"{table} write missing required '{ref_column}'"
        )

    parent = await db.get(parent_model, parent_ref_id)
    if parent is None:
        raise HTTPException(
            status_code=400,
            detail=f"{table} references nonexistent {ref_column}={parent_ref_id}",
        )

    if getattr(parent, "is_default", False):
        raise forbidden(table, entry.id, "write to default-linked")

    if getattr(parent, "user_id", None) != user_id:
        raise forbidden(table, entry.id, "write")


async def apply_put(db: AsyncSession, model, entry: CrudOp, user_id: str, table: str):
    if table in JOIN_OWNED_TABLES:
        await check_join_ownership_for_write(db, entry, user_id, table)

    values = {**entry.data, "id": entry.id}
    if table in OWNED_TABLES:
        values["user_id"] = user_id

    statement = pg_insert(model).values(**values).on_conflict_do_update(
        index_elements=["id"],
        set_={k: v for k, v in values.items() if k != "id"},
    )
    await db.execute(statement)


async def apply_patch(db: AsyncSession, model, entry: CrudOp, user_id: str, table: str):
    row = await db.get(model, entry.id)

    if row is None:
        await apply_put(db, model, entry, user_id, table)
        return

    if table in OWNED_TABLES and getattr(row, "user_id", None) != user_id:
        raise forbidden(table, entry.id, "patch")

    if table in JOIN_OWNED_TABLES:
        _, ref_column = JOIN_OWNED_TABLES[table]
        parent_ref_id = entry.data.get(ref_column, getattr(row, ref_column))
        owner = await join_owner_id(db, table, parent_ref_id)
        if owner != user_id:
            raise forbidden(table, entry.id, "patch")

    for key, value in entry.data.items():
        if key != "user_id":
            setattr(row, key, value)


async def apply_delete(db: AsyncSession, model, entry: CrudOp, user_id: str, table: str):
    row = await db.get(model, entry.id)

    if row is None:
        return

    if table in OWNED_TABLES and getattr(row, "user_id", None) != user_id:
        raise forbidden(table, entry.id, "delete")

    if table in JOIN_OWNED_TABLES:
        _, ref_column = JOIN_OWNED_TABLES[table]
        owner = await join_owner_id(db, table, getattr(row, ref_column))
        if owner != user_id:
            raise forbidden(table, entry.id, "delete")

    await db.execute(sa_delete(model).where(model.id == entry.id))


@app.post(
    "/powersync/upload",
    tags=["PowerSync"],
    summary="Upload CRUD queue to PowerSync",
    responses={
        200: {"description": "Upload successful"},
        400: {"description": "Problem with syntax"},
        401: {"description": "Unauthorized"},
        500: {"description": "Internal server error"},
    },
)
async def upload(
    payload: UploadPayload,
    db: Annotated[AsyncSession, Depends(get_db)],
    user_id: Annotated[str, Depends(get_current_user)],
):
    try:
        for entry in payload.operations:
            model = tables.get(entry.table)
            if model is not None:
                if entry.op == "put":
                    await apply_put(db, model, entry, user_id, entry.table)
                elif entry.op == "patch":
                    await apply_patch(db, model, entry, user_id, entry.table)
                elif entry.op == "delete":
                    await apply_delete(db, model, entry, user_id, entry.table)
        await db.commit()
    except HTTPException:
        await db.rollback()
        raise
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    return {"status": "ok"}