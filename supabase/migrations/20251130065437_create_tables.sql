-- 組織
create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-------------------------------------------------------------------------------
-- 組織メンバー（Supabaseユーザーと組織を紐づけ、ロールを持たせる）
-------------------------------------------------------------------------------
create table organization_members (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,

  -- admin / staff / viewer の3区分
  role text not null check (role in ('admin', 'staff', 'viewer')),

  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null,

  unique (organization_id, user_id)
);

create index idx_organization_members_org_id on organization_members(organization_id);
create index idx_organization_members_user_id on organization_members(user_id);

-------------------------------------------------------------------------------
-- プロジェクト（クラウドファンディング）
-------------------------------------------------------------------------------
create table projects (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  title text not null,
  description text,
  start_at timestamp with time zone not null,
  end_at timestamp with time zone not null,

  -- 大きな金額に対応 numeric(20,0)
  goal numeric(20, 0) not null,

  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create index idx_projects_organization_id on projects(organization_id);

-------------------------------------------------------------------------------
-- カテゴリー
-------------------------------------------------------------------------------
create table categories (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references projects(id) on delete cascade,
  name text not null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create index idx_categories_project_id on categories(project_id);

-------------------------------------------------------------------------------
-- リターン
-------------------------------------------------------------------------------
create table returns (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references projects(id) on delete cascade,
  title text not null,
  detail text,
  max_quantity integer,
  category_id uuid references categories(id) on delete set null,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create index idx_returns_project_id on returns(project_id);
create index idx_returns_category_id on returns(category_id);

-------------------------------------------------------------------------------
-- 支援者
-------------------------------------------------------------------------------
create table supporters (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references projects(id) on delete cascade,
  name text not null,
  address text,
  email text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create index idx_supporters_project_id on supporters(project_id);

-------------------------------------------------------------------------------
-- 納品（リターン × 支援者 × ステータス）
-------------------------------------------------------------------------------
create table deliveries (
  id uuid primary key default gen_random_uuid(),
  return_id uuid not null references returns(id) on delete cascade,
  supporter_id uuid not null references supporters(id) on delete cascade,
  status text not null check (status in ('未着手', '作成中', '完了')),
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create index idx_deliveries_return_id on deliveries(return_id);
create index idx_deliveries_supporter_id on deliveries(supporter_id);
