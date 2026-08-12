CREATE TABLE categories (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('income', 'expense')),
  icon text,
  color text,
  is_default boolean NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE INDEX ix_categories_user ON categories (user_id);

CREATE TABLE imports (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  file_sha256 text NOT NULL,
  original_filename text NOT NULL,
  file_type text NOT NULL CHECK (file_type IN ('pdf', 'csv')),
  account_identifier text,
  imported_at timestamptz NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_import_file_hash_active
  ON imports (user_id, file_sha256)
  WHERE deleted_at IS NULL;

CREATE TABLE recurring_transactions (
  id uuid PRIMARY KEY,
  amount numeric(19,4) NOT NULL,
  type text NOT NULL CHECK (type IN ('income', 'expense')),
  short_description text NOT NULL,
  long_description text,
  next_transaction_date timestamptz NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz,
  currency text NOT NULL DEFAULT 'ZAR',
  unit text NOT NULL CHECK (unit IN ('daily', 'weekly', 'monthly', 'yearly')),
  interval_amount integer NOT NULL,
  start_date timestamptz NOT NULL,
  category_id uuid REFERENCES categories(id),
  user_id text,
  recurring_occurrence_date timestamptz
);
CREATE INDEX ix_recurring_transactions_user ON recurring_transactions (user_id);


CREATE TABLE transactions (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  amount numeric(19,4) NOT NULL,
  type text NOT NULL CHECK (type IN ('income', 'expense')),
  short_description text NOT NULL,
  long_description text,
  transaction_date timestamptz NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz,
  source text NOT NULL CHECK (source IN ('manual', 'import', 'recurring')),
  currency text NOT NULL,
  recurring_id uuid REFERENCES recurring_transactions(id),
  recurring_occurrence_date date,
  import_id uuid REFERENCES imports(id)
);
CREATE INDEX ix_transactions_user_date
  ON transactions (user_id, transaction_date DESC);


CREATE UNIQUE INDEX ux_recurring_occurrence_active
  ON transactions (recurring_id, recurring_occurrence_date)
  WHERE recurring_id IS NOT NULL
    AND recurring_occurrence_date IS NOT NULL
    AND deleted_at IS NULL;


CREATE TABLE transaction_category_map (
  transaction_id uuid PRIMARY KEY REFERENCES transactions(id),
  category_id uuid NOT NULL REFERENCES categories(id),
  assigned_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz,
  assignment_source text NOT NULL CHECK (assignment_source IN ('manual', 'ai', 'import'))
);

CREATE TABLE budget_templates (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  category_id uuid REFERENCES categories(id),
  amount numeric(19,4) NOT NULL,
  period_type text NOT NULL CHECK (period_type IN ('daily', 'weekly', 'monthly', 'yearly')),
  currency text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_budget_templates_one_active_category
  ON budget_templates (user_id, category_id)
  WHERE category_id IS NOT NULL AND deleted_at IS NULL;

CREATE TABLE budget_periods (
  id uuid PRIMARY KEY,
  template_id uuid NOT NULL REFERENCES budget_templates(id),
  period_key text NOT NULL,
  start_date timestamptz NOT NULL,
  end_date timestamptz NOT NULL,
  budgeted_amount numeric(19,4) NOT NULL,
  is_overridden boolean NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_budget_period_active
  ON budget_periods (template_id, period_key)
  WHERE deleted_at IS NULL;
