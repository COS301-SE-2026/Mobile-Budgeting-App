import os
import secrets
import uuid
from datetime import datetime, timezone
from typing import Annotated

from dotenv import load_dotenv
from fastapi import FastAPI, Depends, HTTPException, Header
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy import delete as sa_delete, select as sa_select, and_, or_
from sqlalchemy import Date, DateTime

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
    GoalTemplate,
    GoalPeriod,
    GoalContribution,
    BudgetMember,
    GoalMember,
    UserProfile,
    FriendRequest,
    Friendship,
)
from schema import UploadPayload, CrudOp, FriendRequestIn, FriendRequestIdIn
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
    "goal_templates": GoalTemplate,
    "goal_periods": GoalPeriod,
    "goal_contributions": GoalContribution,
    "budget_members": BudgetMember,
    "goal_members": GoalMember,
    "user_profiles": UserProfile,
    "friend_requests": FriendRequest,
    "friendships": Friendship,
}

# Single-owner tables: user_id is the owner and there is no sharing.
OWNED_TABLES = {
    "categories",
    "transactions",
    "recurring_transactions",
    "imports",
    "user_profiles",
}

# Shared "template" tables: user_id is the creator/owner, but co-owners listed in
# a membership table may also read/write.
# Maps table -> (membership model, FK column on the membership row).
SHARED_TEMPLATES = {
    "budget_templates": (BudgetMember, "budget_template_id"),
    "goal_templates": (GoalMember, "goal_template_id"),
}

# Join-owned tables: ownership is derived from a parent row, which may itself be
# a plain owned table or a shared template.
JOIN_OWNED_TABLES = {
    "category_closure": (Category, "descendant_id"),
    "transaction_category_map": (Transaction, "transaction_id"),
    "budget_periods": (BudgetTemplate, "template_id"),
    "goal_periods": (GoalTemplate, "template_id"),
    "goal_contributions": (GoalTemplate, "template_id"),
}

# Membership tables: one row per co-owner. The writer must be a participant
# (owner or co-owner) of the referenced template.
MEMBERSHIP_TABLES = {
    "budget_members": (BudgetTemplate, "budget_template_id"),
    "goal_members": (GoalTemplate, "goal_template_id"),
}

# Two-party tables: the writer must be one of the two referenced users.
TWO_PARTY_TABLES = {
    "friend_requests": ("requester_id", "addressee_id"),
    "friendships": ("user_a", "user_b"),
}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.on_event("startup")
async def on_startup():
    await init_db()
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


load_dotenv()

COGNITO_REGION = os.getenv("COGNITO_REGION")
COGNITO_USER_POOL_ID = os.getenv("COGNITO_USER_POOL_ID")
COGNITO_APP_CLIENT_ID = os.getenv("COGNITO_APP_CLIENT_ID")

COGNITO_JWKS_URL = (
    f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/"
    f"{COGNITO_USER_POOL_ID}/.well-known/jwks.json"
)
jwks_client = PyJWKClient(COGNITO_JWKS_URL)


async def get_current_user(authorization: str = Header(...)) -> str:
    token = authorization.replace("Bearer ", "")
    try:
        signing_key = jwks_client.get_signing_key_from_jwt(token)
        payload = jwt.decode(
            token,
            signing_key.key,
            algorithms=["RS256"],
            audience=COGNITO_APP_CLIENT_ID,
        )
        return payload["sub"]
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")


def forbidden(table: str, entry_id: str, action: str) -> HTTPException:
    return HTTPException(
        status_code=403,
        detail=f"User is not authorized to {action} {table} with id {entry_id}",
    )


async def _shared_participant(db: AsyncSession, template_table: str, template_id: str, user_id: str) -> bool:
    """True if user_id owns the template or is a (non-deleted) co-owner."""
    member_model, member_fk_col = SHARED_TEMPLATES[template_table]
    template = await db.get(tables[template_table], template_id)
    if template is None:
        return False
    if getattr(template, "user_id", None) == user_id:
        return True
    stmt = sa_select(member_model).where(
        getattr(member_model, member_fk_col) == template_id,
        member_model.user_id == user_id,
        member_model.deleted_at.is_(None),
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none() is not None


async def join_owner_id(db: AsyncSession, table: str, parent_ref_id: str) -> str | None:
    parent_model, _ = JOIN_OWNED_TABLES[table]
    parent = await db.get(parent_model, parent_ref_id)
    return getattr(parent, "user_id", None) if parent else None


async def check_join_ownership_for_write(
    db: AsyncSession, entry: CrudOp, user_id: str, table: str
):
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

    parent_table = parent_model.__tablename__
    if parent_table in SHARED_TEMPLATES:
        allowed = await _shared_participant(db, parent_table, parent_ref_id, user_id)
    else:
        allowed = getattr(parent, "user_id", None) == user_id

    if not allowed:
        raise forbidden(table, entry.id, "write")

    return parent


async def _prepare_put(db: AsyncSession, entry: CrudOp, user_id: str, table: str) -> dict:
    """Validates a create/upsert and returns the effective row data."""
    data = dict(entry.data)

    if table in OWNED_TABLES:
        data["user_id"] = user_id
    elif table in SHARED_TEMPLATES:
        data["user_id"] = user_id
    elif table in JOIN_OWNED_TABLES:
        parent = await check_join_ownership_for_write(db, entry, user_id, table)
        data["user_id"] = getattr(parent, "user_id", None)
        if table == "category_closure":
            data["is_default"] = getattr(parent, "is_default", False)
    elif table in MEMBERSHIP_TABLES:
        parent_model, fk_col = MEMBERSHIP_TABLES[table]
        parent_ref_id = data.get(fk_col)
        if parent_ref_id is None:
            raise HTTPException(
                status_code=400, detail=f"{table} write missing required '{fk_col}'"
            )
        if not await _shared_participant(db, parent_model.__tablename__, parent_ref_id, user_id):
            raise forbidden(table, entry.id, "write")
    elif table in TWO_PARTY_TABLES:
        col_a, col_b = TWO_PARTY_TABLES[table]
        if table == "friend_requests":
            data["requester_id"] = user_id
            if not data.get("addressee_id"):
                raise HTTPException(
                    status_code=400, detail="friend_requests write requires 'addressee_id'"
                )
            if data.get("addressee_id") == user_id:
                raise HTTPException(
                    status_code=400, detail="Cannot send a friend request to yourself"
                )
        elif table == "friendships":
            a = data.get(col_a)
            b = data.get(col_b)
            if a is None or b is None:
                raise HTTPException(
                    status_code=400, detail="friendships write requires 'user_a' and 'user_b'"
                )
            if user_id not in (a, b):
                raise forbidden(table, entry.id, "write")
            if a > b:
                data[col_a], data[col_b] = b, a

    return data


_MICROS_EPOCH_THRESHOLD = 100_000_000_000_000


def _column_types(model):
    return {column.name: column.type for column in model.__table__.columns}


def _coerce_datetime_column(value, column_type):
    if isinstance(value, bool):
        return value

    if isinstance(value, str):
        # drift (storeDateTimeValuesAsText) sends datetimes as ISO-8601 text,
        # e.g. "2026-09-02T16:06:56.021464Z". asyncpg needs a real datetime.
        if isinstance(column_type, (DateTime, Date)):
            parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
            return parsed.date() if isinstance(column_type, Date) else parsed
        return value

    if not isinstance(value, (int, float)):
        return value

    epoch = float(value)
    if abs(epoch) >= _MICROS_EPOCH_THRESHOLD:
        epoch /= 1_000_000

    if isinstance(column_type, DateTime):
        return datetime.fromtimestamp(epoch, tz=timezone.utc)
    if isinstance(column_type, Date):
        return datetime.fromtimestamp(epoch, tz=timezone.utc).date()
    return value


def _coerce_row_values(model, values):
    column_types = _column_types(model)
    return {
        key: _coerce_datetime_column(value, column_types.get(key))
        for key, value in values.items()
    }


async def apply_put(db: AsyncSession, model, entry: CrudOp, user_id: str, table: str):
    data = await _prepare_put(db, entry, user_id, table)
    values = {**data, "id": entry.id}
    values = _coerce_row_values(model, values)

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

    if table in OWNED_TABLES:
        if getattr(row, "user_id", None) != user_id:
            raise forbidden(table, entry.id, "patch")
    elif table in SHARED_TEMPLATES:
        if not await _shared_participant(db, table, entry.id, user_id):
            raise forbidden(table, entry.id, "patch")
    elif table in JOIN_OWNED_TABLES:
        parent_model, ref_column = JOIN_OWNED_TABLES[table]
        parent_ref_id = entry.data.get(ref_column, getattr(row, ref_column))
        if parent_model.__tablename__ in SHARED_TEMPLATES:
            if not await _shared_participant(db, parent_model.__tablename__, parent_ref_id, user_id):
                raise forbidden(table, entry.id, "patch")
        else:
            owner = await join_owner_id(db, table, parent_ref_id)
            if owner != user_id:
                raise forbidden(table, entry.id, "patch")
    elif table in MEMBERSHIP_TABLES:
        parent_model, fk_col = MEMBERSHIP_TABLES[table]
        parent_ref_id = entry.data.get(fk_col, getattr(row, fk_col))
        if not await _shared_participant(db, parent_model.__tablename__, parent_ref_id, user_id):
            raise forbidden(table, entry.id, "patch")
    elif table in TWO_PARTY_TABLES:
        col_a, col_b = TWO_PARTY_TABLES[table]
        if user_id not in (getattr(row, col_a), getattr(row, col_b)):
            raise forbidden(table, entry.id, "patch")

    column_types = _column_types(model)
    for key, value in entry.data.items():
        if key not in ("user_id", "is_default"):
            setattr(row, key, _coerce_datetime_column(value, column_types.get(key)))


async def apply_delete(db: AsyncSession, model, entry: CrudOp, user_id: str, table: str):
    row = await db.get(model, entry.id)

    if row is None:
        return

    if table in OWNED_TABLES:
        if getattr(row, "user_id", None) != user_id:
            raise forbidden(table, entry.id, "delete")
    elif table in SHARED_TEMPLATES:
        if not await _shared_participant(db, table, entry.id, user_id):
            raise forbidden(table, entry.id, "delete")
    elif table in JOIN_OWNED_TABLES:
        parent_model, ref_column = JOIN_OWNED_TABLES[table]
        parent_ref_id = getattr(row, ref_column)
        if parent_model.__tablename__ in SHARED_TEMPLATES:
            if not await _shared_participant(db, parent_model.__tablename__, parent_ref_id, user_id):
                raise forbidden(table, entry.id, "delete")
        else:
            owner = await join_owner_id(db, table, parent_ref_id)
            if owner != user_id:
                raise forbidden(table, entry.id, "delete")
    elif table in MEMBERSHIP_TABLES:
        parent_model, fk_col = MEMBERSHIP_TABLES[table]
        parent_ref_id = getattr(row, fk_col)
        # A member may always remove themselves; removing others requires
        # being a participant (owner or co-owner).
        if getattr(row, "user_id", None) != user_id:
            if not await _shared_participant(db, parent_model.__tablename__, parent_ref_id, user_id):
                raise forbidden(table, entry.id, "delete")
    elif table in TWO_PARTY_TABLES:
        col_a, col_b = TWO_PARTY_TABLES[table]
        if user_id not in (getattr(row, col_a), getattr(row, col_b)):
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


# ── Friends / profiles ────────────────────────────────────────────────────────

FRIEND_CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"


def _random_friend_code() -> str:
    return "".join(secrets.choice(FRIEND_CODE_ALPHABET) for _ in range(8))


async def _generate_unique_friend_code(db: AsyncSession) -> str:
    for _ in range(20):
        code = _random_friend_code()
        exists = (
            await db.execute(sa_select(UserProfile).where(UserProfile.friend_code == code))
        ).scalar_one_or_none()
        if exists is None:
            return code
    raise HTTPException(status_code=500, detail="Could not generate a unique friend code")


@app.get("/me/profile", tags=["Friends"])
async def get_my_profile(
    db: Annotated[AsyncSession, Depends(get_db)],
    user_id: Annotated[str, Depends(get_current_user)],
):
    """Returns the caller's profile, creating it (with a friend code) on first use."""
    profile = (
        await db.execute(sa_select(UserProfile).where(UserProfile.user_id == user_id))
    ).scalar_one_or_none()

    if profile is None:
        now = datetime.now(timezone.utc)
        profile = UserProfile(
            id=str(uuid.uuid4()),
            user_id=user_id,
            friend_code=await _generate_unique_friend_code(db),
            created_at=now,
            updated_at=now,
        )
        db.add(profile)
        await db.commit()
        await db.refresh(profile)

    return {
        "user_id": profile.user_id,
        "friend_code": profile.friend_code,
        "created_at": profile.created_at,
        "updated_at": profile.updated_at,
    }


@app.post("/friends/request", tags=["Friends"])
async def send_friend_request(
    payload: FriendRequestIn,
    db: Annotated[AsyncSession, Depends(get_db)],
    user_id: Annotated[str, Depends(get_current_user)],
):
    """Resolves a friend code and creates a pending friend request."""
    code = payload.friend_code.strip().upper()
    target = (
        await db.execute(sa_select(UserProfile).where(UserProfile.friend_code == code))
    ).scalar_one_or_none()
    if target is None:
        raise HTTPException(status_code=404, detail="Friend code not found")

    target_id = target.user_id
    if target_id == user_id:
        raise HTTPException(status_code=400, detail="You cannot add yourself")

    a, b = (user_id, target_id) if user_id < target_id else (target_id, user_id)
    friendship = (
        await db.execute(
            sa_select(Friendship).where(
                Friendship.user_a == a,
                Friendship.user_b == b,
                Friendship.deleted_at.is_(None),
            )
        )
    ).scalar_one_or_none()
    if friendship is not None:
        raise HTTPException(status_code=409, detail="Already friends")

    pending = (
        await db.execute(
            sa_select(FriendRequest).where(
                FriendRequest.status == "pending",
                FriendRequest.deleted_at.is_(None),
                or_(
                    and_(
                        FriendRequest.requester_id == user_id,
                        FriendRequest.addressee_id == target_id,
                    ),
                    and_(
                        FriendRequest.requester_id == target_id,
                        FriendRequest.addressee_id == user_id,
                    ),
                ),
            )
        )
    ).scalar_one_or_none()
    if pending is not None:
        raise HTTPException(status_code=409, detail="A pending request already exists")

    now = datetime.now(timezone.utc)
    request = FriendRequest(
        id=str(uuid.uuid4()),
        requester_id=user_id,
        addressee_id=target_id,
        status="pending",
        created_at=now,
        updated_at=now,
    )
    db.add(request)
    await db.commit()
    await db.refresh(request)
    return {"request_id": request.id, "status": request.status, "addressee_id": request.addressee_id}


@app.post("/friends/accept", tags=["Friends"])
async def accept_friend_request(
    payload: FriendRequestIdIn,
    db: Annotated[AsyncSession, Depends(get_db)],
    user_id: Annotated[str, Depends(get_current_user)],
):
    """Accepts a pending request and creates the friendship."""
    request = await db.get(FriendRequest, payload.request_id)
    if request is None:
        raise HTTPException(status_code=404, detail="Friend request not found")
    if request.addressee_id != user_id:
        raise HTTPException(status_code=403, detail="Only the recipient can accept this request")
    if request.status != "pending":
        raise HTTPException(status_code=409, detail="Request is not pending")

    now = datetime.now(timezone.utc)
    request.status = "accepted"
    request.updated_at = now

    a, b = (
        (request.requester_id, request.addressee_id)
        if request.requester_id < request.addressee_id
        else (request.addressee_id, request.requester_id)
    )
    existing = (
        await db.execute(
            sa_select(Friendship).where(
                Friendship.user_a == a,
                Friendship.user_b == b,
                Friendship.deleted_at.is_(None),
            )
        )
    ).scalar_one_or_none()
    if existing is None:
        db.add(Friendship(id=str(uuid.uuid4()), user_a=a, user_b=b, created_at=now, updated_at=now))

    await db.commit()
    return {"status": "accepted"}


@app.post("/friends/decline", tags=["Friends"])
async def decline_friend_request(
    payload: FriendRequestIdIn,
    db: Annotated[AsyncSession, Depends(get_db)],
    user_id: Annotated[str, Depends(get_current_user)],
):
    """Declines a pending friend request."""
    request = await db.get(FriendRequest, payload.request_id)
    if request is None:
        raise HTTPException(status_code=404, detail="Friend request not found")
    if request.addressee_id != user_id:
        raise HTTPException(status_code=403, detail="Only the recipient can decline this request")

    request.status = "declined"
    request.updated_at = datetime.now(timezone.utc)
    await db.commit()
    return {"status": "declined"}
