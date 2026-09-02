
import enum
import uuid
from datetime import date, datetime
from decimal import Decimal
from database import Base

from sqlalchemy import (
    Boolean,
    Date,
    DateTime,
    Enum as SAEnum,
    ForeignKey,
    Integer,
    Numeric,
    String,
    UniqueConstraint,
    UUID,
)
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column



class CategoryType(str, enum.Enum):
    income = "income"
    expense = "expense"


class TransactionType(str, enum.Enum):
    income = "income"
    expense = "expense"


class TransactionSource(str, enum.Enum):
    manual = "manual"
    import_ = "import"
    recurring = "recurring"


class AssignmentSource(str, enum.Enum):
    manual = "manual"
    ai = "ai"
    import_ = "import"


class PeriodType(str, enum.Enum):
    daily = "daily"
    weekly = "weekly"
    monthly = "monthly"
    yearly = "yearly"


class ImportFileType(str, enum.Enum):
    pdf = "pdf"
    csv = "csv"


def _uuid() -> str:
    return str(uuid.uuid4())




class Category(Base):
 

    __tablename__ = "categories"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    name: Mapped[str] = mapped_column(String)
    type: Mapped[CategoryType] = mapped_column(SAEnum(CategoryType, native_enum=False))
    icon: Mapped[str | None] = mapped_column(String, nullable=True)
    color: Mapped[str | None] = mapped_column(String, nullable=True)
    is_default: Mapped[bool] = mapped_column(Boolean)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    user_id: Mapped[str] = mapped_column(String)


class CategoryClosure(Base):
   
    __tablename__ = "category_closure"
    __table_args__ = (UniqueConstraint("ancestor_id", "descendant_id"),)

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    ancestor_id: Mapped[str] = mapped_column(ForeignKey("categories.id"))
    descendant_id: Mapped[str] = mapped_column(ForeignKey("categories.id"))
    user_id: Mapped[str] = mapped_column(String)
    is_default: Mapped[bool] = mapped_column(Boolean)
    depth: Mapped[int] = mapped_column(Integer)


class Transaction(Base):
  

    __tablename__ = "transactions"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    amount: Mapped[Decimal] = mapped_column(Numeric(19, 4))
    type: Mapped[TransactionType] = mapped_column(SAEnum(TransactionType, native_enum=False))
    short_description: Mapped[str] = mapped_column(String(100))
    long_description: Mapped[str | None] = mapped_column(String(500), nullable=True)
    transaction_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    source: Mapped[TransactionSource] = mapped_column(SAEnum(TransactionSource, native_enum=False))
    currency: Mapped[str] = mapped_column(String, default="ZAR", server_default="ZAR")
    recurring_id: Mapped[str | None] = mapped_column(
        ForeignKey("recurring_transactions.id"), nullable=True
    )
    recurring_occurrence_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    user_id: Mapped[str] = mapped_column(String)
    import_id: Mapped[str | None] = mapped_column(ForeignKey("imports.id"), nullable=True)


class TransactionCategoryMap(Base):
    

    __tablename__ = "transaction_category_map"
    __table_args__ = (UniqueConstraint("transaction_id"),)

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    transaction_id: Mapped[str] = mapped_column(
        ForeignKey("transactions.id")
    )
    category_id: Mapped[str] = mapped_column(ForeignKey("categories.id"))
    user_id: Mapped[str] = mapped_column(String)
    assigned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    assignment_source: Mapped[AssignmentSource] = mapped_column(
        SAEnum(AssignmentSource, native_enum=False)
    )


class BudgetTemplate(Base):
 
    __tablename__ = "budget_templates"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    category_id: Mapped[str | None] = mapped_column(ForeignKey("categories.id"), nullable=True)
    amount: Mapped[Decimal] = mapped_column(Numeric(19, 4))
    period_type: Mapped[PeriodType] = mapped_column(SAEnum(PeriodType, native_enum=False))
    currency: Mapped[str] = mapped_column(String, default="ZAR", server_default="ZAR")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    user_id: Mapped[str] = mapped_column(String)


class BudgetPeriod(Base):
   

    __tablename__ = "budget_periods"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    template_id: Mapped[str] = mapped_column(ForeignKey("budget_templates.id"))
    user_id: Mapped[str] = mapped_column(String)
    period_key: Mapped[str] = mapped_column(String)
    start_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    end_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    budgeted_amount: Mapped[Decimal] = mapped_column(Numeric(19, 4))
    is_overridden: Mapped[bool] = mapped_column(Boolean)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class RecurringTransaction(Base):
   

    __tablename__ = "recurring_transactions"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    amount: Mapped[Decimal] = mapped_column(Numeric(19, 4))
    type: Mapped[TransactionType] = mapped_column(SAEnum(TransactionType, native_enum=False))
    short_description: Mapped[str] = mapped_column(String)
    long_description: Mapped[str | None] = mapped_column(String, nullable=True)
    next_transaction_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    currency: Mapped[str] = mapped_column(String, default="ZAR", server_default="ZAR")
    unit: Mapped[PeriodType] = mapped_column(SAEnum(PeriodType, native_enum=False))
    interval_amount: Mapped[int] = mapped_column(Integer)
    start_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    category_id: Mapped[str | None] = mapped_column(ForeignKey("categories.id"), nullable=True)
    user_id: Mapped[str | None] = mapped_column(String, nullable=True)
    recurring_occurrence_date: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )


class Import(Base):
   

    __tablename__ = "imports"

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True, default=_uuid)
    user_id: Mapped[str] = mapped_column(String)
    file_sha256: Mapped[str] = mapped_column(String)
    original_filename: Mapped[str] = mapped_column(String)
    file_type: Mapped[ImportFileType] = mapped_column(SAEnum(ImportFileType, native_enum=False))
    account_identifier: Mapped[str | None] = mapped_column(String, nullable=True)
    imported_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
