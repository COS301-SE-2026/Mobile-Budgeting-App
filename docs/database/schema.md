---
title: Mobile Budgeting App — MVP SQLite Schema
config:
  layout: elk
---
erDiagram
    CATEGORIES {
        string id PK
        string name
        enum type "income | expense"
        string icon "nullable"
        string color "nullable"
        boolean is_default
        datetime created_at
        datetime updated_at
        datetime deleted_at "nullable, soft delete"
    }

    CATEGORY_CLOSURE {
        string ancestor_id FK
        string descendant_id FK
        int depth
    }

    TRANSACTIONS {
        string id PK
        decimal amount "positive value"
        enum type "income | expense"
        string short_description "max 100 chars"
        string long_description "nullable, max 500 chars"
        datetime transaction_date "real-world date"
        datetime created_at "date entered into app"
        datetime updated_at
        datetime deleted_at "nullable, soft delete"
        enum source "manual | import | recurring"
        enum currency "default ZAR"
    }

    TRANSACTION_CATEGORY_MAP {
        string transaction_id FK "unique"
        string category_id FK
        datetime assigned_at
        enum assignment_source "manual | ai | import"
    }

    BUDGET_TEMPLATES {
        string id PK
        string category_id FK
        decimal amount
        enum period_type "daily | weekly | monthly | yearly"
        enum currency "default ZAR"
        datetime created_at
        datetime updated_at
        datetime deleted_at "nullable, soft delete"
    }

    BUDGET_PERIODS {
        string id PK
        string template_id FK
        date start_date
        date end_date
        decimal budgeted_amount "copied from template, overrideable"
        boolean is_overridden
        datetime created_at
        datetime updated_at
    }

    APP_SETTINGS {
        string key PK
        string value
        datetime updated_at
    }

    CATEGORIES ||--o{ CATEGORY_CLOSURE : "ancestor in"
    CATEGORIES ||--o{ CATEGORY_CLOSURE : "descendant in"
    CATEGORIES ||--o{ TRANSACTION_CATEGORY_MAP : "assigned to"
    CATEGORIES ||--o{ BUDGET_TEMPLATES : "budgeted by"
    TRANSACTIONS ||--o| TRANSACTION_CATEGORY_MAP : "mapped via"
    BUDGET_TEMPLATES ||--o{ BUDGET_PERIODS : "instantiates"
