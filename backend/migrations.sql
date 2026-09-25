-- =============================================================================
-- Migration for existing databases: friends, goals and sharing features.
--
-- schema.sql only runs when the Postgres volume is first created. For an
-- existing database, run this script (e.g. `psql <db> -f migrations.sql`) to
-- bring it in line with schema.sql.
--
-- NOTE: the backend's `Base.metadata.create_all` already creates the *new*
-- tables on startup, but it does NOT add columns, drop indexes, or alter the
-- publication — which is why those steps are included here explicitly.
-- =============================================================================

-- 1. Multiple budgets per category: add a label and drop the one-per-category index.
ALTER TABLE budget_templates ADD COLUMN IF NOT EXISTS name text;
DROP INDEX IF EXISTS ux_budget_templates_one_active_category;

-- 2. Goals (income targets), mirroring budgets.
CREATE TABLE IF NOT EXISTS goal_templates (
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

CREATE TABLE IF NOT EXISTS goal_periods (
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
CREATE UNIQUE INDEX IF NOT EXISTS ux_goal_period_active
  ON goal_periods (template_id, period_key)
  WHERE deleted_at IS NULL;

-- 3. Sharing (equal co-owners) for budgets and goals.
CREATE TABLE IF NOT EXISTS budget_members (
  id uuid PRIMARY KEY,
  budget_template_id uuid NOT NULL REFERENCES budget_templates(id),
  user_id text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_budget_members_active
  ON budget_members (budget_template_id, user_id)
  WHERE deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS goal_members (
  id uuid PRIMARY KEY,
  goal_template_id uuid NOT NULL REFERENCES goal_templates(id),
  user_id text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_goal_members_active
  ON goal_members (goal_template_id, user_id)
  WHERE deleted_at IS NULL;

-- 4. Friends.
CREATE TABLE IF NOT EXISTS user_profiles (
  id uuid PRIMARY KEY,
  user_id text NOT NULL,
  friend_code text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_user_profiles_user ON user_profiles (user_id);
CREATE UNIQUE INDEX IF NOT EXISTS ux_user_profiles_friend_code ON user_profiles (friend_code);

CREATE TABLE IF NOT EXISTS friend_requests (
  id uuid PRIMARY KEY,
  requester_id text NOT NULL,
  addressee_id text NOT NULL,
  status text NOT NULL CHECK (status IN ('pending', 'accepted', 'declined')),
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_friend_requests_pending
  ON friend_requests (requester_id, addressee_id)
  WHERE status = 'pending' AND deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS friendships (
  id uuid PRIMARY KEY,
  user_a text NOT NULL,
  user_b text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_friendships_pair
  ON friendships (user_a, user_b)
  WHERE deleted_at IS NULL;

-- 5. Add the new tables to the PowerSync publication (Postgres 10+).
ALTER PUBLICATION powersync ADD TABLE
  public.goal_templates,
  public.goal_periods,
  public.budget_members,
  public.goal_members,
  public.user_profiles,
  public.friend_requests,
  public.friendships;

CREATE TABLE IF NOT EXISTS goal_contributions (
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
CREATE INDEX IF NOT EXISTS ix_goal_contributions_template
  ON goal_contributions (template_id)
  WHERE deleted_at IS NULL;

ALTER PUBLICATION powersync ADD TABLE public.goal_contributions;
