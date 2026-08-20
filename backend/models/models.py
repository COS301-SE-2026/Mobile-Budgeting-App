
import enum
import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import (
    Boolean,
    DateTime,
    Enum as SAEnum,
    ForeignKey,
    Integer,
    Numeric,
    String,
)
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


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
    """Category definitions used for tracking income and expenses.

    Supports soft deletion via `deleted_at` and marks built-in categories
    via `is_default`.
    """

    __tablename__ = "categories"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=_uuid)
    name: Mapped[str] = mapped_column(String)
    type: Mapped[CategoryType] = mapped_column(SAEnum(CategoryType, native_enum=False))
    icon: Mapped[str | None] = mapped_column(String, nullable=True)
    color: Mapped[str | None] = mapped_column(String, nullable=True)
    is_default: Mapped[bool] = mapped_column(Boolean)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    user_id: Mapped[str | None] = mapped_column(String, nullable=True)


class CategoryClosure(Base):
    """Closure table storing ancestor/descendant relationships between
    categories, enabling efficient subtree/ancestor queries.
    """

    __tablename__ = "category_closure"

    ancestor_id: Mapped[str] = mapped_column(ForeignKey("categories.id"), primary_key=True)
    descendant_id: Mapped[str] = mapped_column(ForeignKey("categories.id"), primary_key=True)
    depth: Mapped[int] = mapped_column(Integer)


class Transaction(Base):
    """Individual income and expense transactions.

    Linked to categories via `TransactionCategoryMap`, and optionally to a
    recurring template or an import batch.
    """

    __tablename__ = "transactions"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=_uuid)
    amount: Mapped[Decimal] = mapped_column(Numeric(14, 2))
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
    user_id: Mapped[str | None] = mapped_column(String, nullable=True)
    import_id: Mapped[str | None] = mapped_column(ForeignKey("imports.id"), nullable=True)


class TransactionCategoryMap(Base):
    """Maps a transaction to a single category, with metadata about how the
    assignment was made (manual, AI-suggested, or from an import).
    """

    __tablename__ = "transaction_category_map"

    transaction_id: Mapped[str] = mapped_column(
        ForeignKey("transactions.id"), primary_key=True
    )
    category_id: Mapped[str] = mapped_column(ForeignKey("categories.id"))
    assigned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    assignment_source: Mapped[AssignmentSource] = mapped_column(
        SAEnum(AssignmentSource, native_enum=False)
    )


class BudgetTemplate(Base):
    """A recurring budget amount for a category over a time period.

    `BudgetPeriod` rows are generated from a template and track actual
    budgeted amounts for each period.
    """

    __tablename__ = "budget_templates"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=_uuid)
    category_id: Mapped[str | None] = mapped_column(ForeignKey("categories.id"), nullable=True)
    amount: Mapped[Decimal] = mapped_column(Numeric(14, 2))
    period_type: Mapped[PeriodType] = mapped_column(SAEnum(PeriodType, native_enum=False))
    currency: Mapped[str] = mapped_column(String, default="ZAR", server_default="ZAR")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    user_id: Mapped[str | None] = mapped_column(String, nullable=True)


class BudgetPeriod(Base):
    """A specific budget period generated from a `BudgetTemplate`.

    Can be manually overridden via `is_overridden`.
    """

    __tablename__ = "budget_periods"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=_uuid)
    template_id: Mapped[str] = mapped_column(ForeignKey("budget_templates.id"))
    start_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    end_date: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    budgeted_amount: Mapped[Decimal] = mapped_column(Numeric(14, 2))
    is_overridden: Mapped[bool] = mapped_column(Boolean)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class RecurringTransaction(Base):
    """Recurring transaction templates.

    Generates child rows in `Transaction` when they occur, on an interval
    of `unit` (daily/weekly/monthly/yearly) repeated every
    `interval_amount` periods.
    """

    __tablename__ = "recurring_transactions"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=_uuid)
    amount: Mapped[Decimal] = mapped_column(Numeric(14, 2))
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


class AppSetting(Base):
    """Key-value settings for the application (e.g. default currency,
    theme mode, onboarding status).
    """

    __tablename__ = "app_settings"

    key: Mapped[str] = mapped_column(String, primary_key=True)
    value: Mapped[str] = mapped_column(String)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))


class Import(Base):
    """A single PDF/CSV statement import batch that transactions can be
    traced back to via `Transaction.import_id`.
    """

    __tablename__ = "imports"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=_uuid)
    user_id: Mapped[str | None] = mapped_column(String, nullable=True)
    file_sha256: Mapped[str] = mapped_column(String)
    original_file_name: Mapped[str] = mapped_column(String)
    file_type: Mapped[ImportFileType] = mapped_column(SAEnum(ImportFileType, native_enum=False))
    account_identifier: Mapped[str | None] = mapped_column(String, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)