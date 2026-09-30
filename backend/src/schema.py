from pydantic import BaseModel
from typing import Literal, Any

class CrudOp(BaseModel):
    id: str
    op: Literal["put", "patch", "delete"]
    table: str
    data: dict[str, Any]

class UploadPayload(BaseModel):
    operations: list[CrudOp]


class FriendRequestIn(BaseModel):
    friend_code: str


class FriendRequestIdIn(BaseModel):
    request_id: str