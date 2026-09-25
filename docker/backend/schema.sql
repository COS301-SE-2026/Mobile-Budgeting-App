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
  recurring_occurrence_date timestamptz,
  import_id uuid REFERENCES imports(id)
);
CREATE INDEX ix_transactions_user_date
  ON transactions (user_id, transaction_date DESC);


CREATE UNIQUE INDEX ux_recurring_occurrence_active
  ON transactions (recurring_id, recurring_occurrence_date)
  WHERE recurring_id IS NOT NULL
    AND recurring_occurrence_date IS NOT NULL
    AND deleted_at IS NULL;


CREATE TABLE budget_templates (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  name text,
  category_id uuid REFERENCES categories(id),
  amount numeric(19,4) NOT NULL,
  period_type text NOT NULL CHECK (period_type IN ('daily', 'weekly', 'monthly', 'yearly')),
  currency text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
-- Multiple budgets per category are now supported, so the
-- ux_budget_templates_one_active_category index has been removed.

CREATE TABLE budget_periods (
  id uuid PRIMARY KEY,
  template_id uuid NOT NULL REFERENCES budget_templates(id),
  user_id text NOT NULL,
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

CREATE TABLE category_closure (
    id uuid PRIMARY KEY,
    ancestor_id uuid NOT NULL REFERENCES categories(id),
    descendant_id uuid NOT NULL REFERENCES categories(id),
    user_id text NOT NULL,
    is_default boolean NOT NULL,
    depth INTEGER NOT NULL,
    UNIQUE (ancestor_id, descendant_id)
);

CREATE TABLE transaction_category_map (
    id uuid PRIMARY KEY,
    transaction_id uuid NOT NULL REFERENCES transactions(id),
    category_id uuid NOT NULL REFERENCES categories(id),
    user_id text NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,
    deleted_at TIMESTAMPTZ,
    assignment_source TEXT NOT NULL,
    UNIQUE (transaction_id)
);

CREATE TABLE goal_templates (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  name text,
  category_id uuid REFERENCES categories(id),
  target_amount numeric(19,4) NOT NULL,
  period_type text NOT NULL CHECK (period_type IN ('daily', 'weekly', 'monthly', 'yearly')),
  currency text NOT NULL DEFAULT 'ZAR',
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);

CREATE TABLE goal_periods (
  id uuid PRIMARY KEY,
  template_id uuid NOT NULL REFERENCES goal_templates(id),
  user_id text NOT NULL,
  period_key text NOT NULL,
  start_date timestamptz NOT NULL,
  end_date timestamptz NOT NULL,
  target_amount numeric(19,4) NOT NULL,
  is_overridden boolean NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_goal_period_active
  ON goal_periods (template_id, period_key)
  WHERE deleted_at IS NULL;

CREATE TABLE goal_contributions (
  id uuid PRIMARY KEY,
  template_id uuid NOT NULL REFERENCES goal_templates(id),
  user_id text NOT NULL,
  amount numeric(19,4) NOT NULL,
  note text,
  transaction_id uuid REFERENCES transactions(id),
  contributed_at timestamptz NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE INDEX ix_goal_contributions_template
  ON goal_contributions (template_id)
  WHERE deleted_at IS NULL;

CREATE TABLE budget_members (
  id uuid PRIMARY KEY,
  budget_template_id uuid NOT NULL REFERENCES budget_templates(id),
  user_id text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_budget_members_active
  ON budget_members (budget_template_id, user_id)
  WHERE deleted_at IS NULL;

CREATE TABLE goal_members (
  id uuid PRIMARY KEY,
  goal_template_id uuid NOT NULL REFERENCES goal_templates(id),
  user_id text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_goal_members_active
  ON goal_members (goal_template_id, user_id)
  WHERE deleted_at IS NULL;

CREATE TABLE user_profiles (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  friend_code text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);
CREATE UNIQUE INDEX ux_user_profiles_user ON user_profiles (user_id);
CREATE UNIQUE INDEX ux_user_profiles_friend_code ON user_profiles (friend_code);

CREATE TABLE friend_requests (
  id uuid PRIMARY KEY,
  requester_id text NOT NULL,
  addressee_id text NOT NULL,
  status text NOT NULL CHECK (status IN ('pending', 'accepted', 'declined')),
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_friend_requests_pending
  ON friend_requests (requester_id, addressee_id)
  WHERE status = 'pending' AND deleted_at IS NULL;

CREATE TABLE friendships (
  id uuid PRIMARY KEY,
  user_a text NOT NULL,
  user_b text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX ux_friendships_pair
  ON friendships (user_a, user_b)
  WHERE deleted_at IS NULL;

CREATE PUBLICATION powersync FOR TABLE public.categories, public.transactions, public.budget_templates, public.recurring_transactions, public.imports, public.budget_periods, public.transaction_category_map, public.category_closure, public.goal_templates, public.goal_periods, public.budget_members, public.goal_members, public.user_profiles, public.friend_requests, public.friendships, public.goal_contributions;
