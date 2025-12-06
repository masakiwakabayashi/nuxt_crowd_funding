--------------------------------------------------------------------------------
-- auth.users を使う前提
--   user_id = auth.users.id
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- organizations
--------------------------------------------------------------------------------
alter table organizations enable row level security;
alter table organizations force row level security;

-- 組織はメンバーであれば閲覧可能
create policy "organizations_select_by_members"
on organizations
for select
using (
  exists (
    select 1
    from organization_members om
    where om.organization_id = organizations.id
      and om.user_id = auth.uid()
  )
);

-- 組織の作成は認証済みユーザーであれば可能（初回オーナー登録は別途処理想定）
create policy "organizations_insert_by_authenticated"
on organizations
for insert
with check (
  auth.role() = 'authenticated'
);

-- 組織の更新は当該組織の admin のみ
create policy "organizations_update_by_admin"
on organizations
for update
using (
  exists (
    select 1
    from organization_members om
    where om.organization_id = organizations.id
      and om.user_id = auth.uid()
      and om.role = 'admin'
  )
)
with check (
  exists (
    select 1
    from organization_members om
    where om.organization_id = organizations.id
      and om.user_id = auth.uid()
      and om.role = 'admin'
  )
);

-- 組織の削除も admin のみ
create policy "organizations_delete_by_admin"
on organizations
for delete
using (
  exists (
    select 1
    from organization_members om
    where om.organization_id = organizations.id
      and om.user_id = auth.uid()
      and om.role = 'admin'
  )
);

--------------------------------------------------------------------------------
-- organization_members
--------------------------------------------------------------------------------
alter table organization_members enable row level security;
alter table organization_members force row level security;

-- 自分の所属情報、または admin として所属する組織のメンバー一覧は閲覧可
create policy "organization_members_select_self_or_admin"
on organization_members
for select
using (
  -- 自分自身の行
  organization_members.user_id = auth.uid()
  or
  -- または当該組織の admin として閲覧
  exists (
    select 1
    from organization_members om_admin
    where om_admin.organization_id = organization_members.organization_id
      and om_admin.user_id = auth.uid()
      and om_admin.role = 'admin'
  )
);

-- メンバーの追加/更新/削除はサービスキーやFUNCTION経由を想定し、
-- 通常のユーザーからは直接操作不可とする（必要に応じて変更）
create policy "organization_members_no_direct_insert"
on organization_members
for insert
with check (false);

create policy "organization_members_no_direct_update"
on organization_members
for update
using (false)
with check (false);

create policy "organization_members_no_direct_delete"
on organization_members
for delete
using (false);

--------------------------------------------------------------------------------
-- projects
--------------------------------------------------------------------------------
alter table projects enable row level security;
alter table projects force row level security;

-- プロジェクトは、所属組織のメンバーであれば閲覧可（ロール問わず）
create policy "projects_select_by_members"
on projects
for select
using (
  exists (
    select 1
    from organization_members om
    where om.organization_id = projects.organization_id
      and om.user_id = auth.uid()
  )
);

-- 作成・更新・削除は admin / staff のみ
create policy "projects_insert_by_admin_or_staff"
on projects
for insert
with check (
  exists (
    select 1
    from organization_members om
    where om.organization_id = projects.organization_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "projects_update_by_admin_or_staff"
on projects
for update
using (
  exists (
    select 1
    from organization_members om
    where om.organization_id = projects.organization_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
)
with check (
  exists (
    select 1
    from organization_members om
    where om.organization_id = projects.organization_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "projects_delete_by_admin_or_staff"
on projects
for delete
using (
  exists (
    select 1
    from organization_members om
    where om.organization_id = projects.organization_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

--------------------------------------------------------------------------------
-- categories
--------------------------------------------------------------------------------
alter table categories enable row level security;
alter table categories force row level security;

-- 閲覧: プロジェクトの所属組織のメンバーならOK
create policy "categories_select_by_members"
on categories
for select
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = categories.project_id
      and om.user_id = auth.uid()
  )
);

-- 作成・更新・削除: admin / staff のみ
create policy "categories_insert_by_admin_or_staff"
on categories
for insert
with check (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = categories.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "categories_update_by_admin_or_staff"
on categories
for update
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = categories.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
)
with check (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = categories.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "categories_delete_by_admin_or_staff"
on categories
for delete
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = categories.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

--------------------------------------------------------------------------------
-- returns
--------------------------------------------------------------------------------
alter table returns enable row level security;
alter table returns force row level security;

-- 閲覧: メンバーならOK
create policy "returns_select_by_members"
on returns
for select
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = returns.project_id
      and om.user_id = auth.uid()
  )
);

-- 作成・更新・削除: admin / staff のみ
create policy "returns_insert_by_admin_or_staff"
on returns
for insert
with check (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = returns.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "returns_update_by_admin_or_staff"
on returns
for update
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = returns.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
)
with check (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = returns.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "returns_delete_by_admin_or_staff"
on returns
for delete
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = returns.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

--------------------------------------------------------------------------------
-- supporters
--------------------------------------------------------------------------------
alter table supporters enable row level security;
alter table supporters force row level security;

-- 閲覧: メンバーであればOK（住所・メール含むので、必要なら viewer 制限も検討）
create policy "supporters_select_by_members"
on supporters
for select
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = supporters.project_id
      and om.user_id = auth.uid()
  )
);

-- 作成・更新・削除: admin / staff のみ
create policy "supporters_insert_by_admin_or_staff"
on supporters
for insert
with check (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = supporters.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "supporters_update_by_admin_or_staff"
on supporters
for update
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = supporters.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
)
with check (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = supporters.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "supporters_delete_by_admin_or_staff"
on supporters
for delete
using (
  exists (
    select 1
    from projects p
    join organization_members om
      on om.organization_id = p.organization_id
    where p.id = supporters.project_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

--------------------------------------------------------------------------------
-- deliveries
--------------------------------------------------------------------------------
alter table deliveries enable row level security;
alter table deliveries force row level security;

-- 閲覧: メンバーならOK
create policy "deliveries_select_by_members"
on deliveries
for select
using (
  exists (
    select 1
    from returns r
    join projects p
      on p.id = r.project_id
    join organization_members om
      on om.organization_id = p.organization_id
    where r.id = deliveries.return_id
      and om.user_id = auth.uid()
  )
);

-- 作成・更新・削除: admin / staff のみ
create policy "deliveries_insert_by_admin_or_staff"
on deliveries
for insert
with check (
  exists (
    select 1
    from returns r
    join projects p
      on p.id = r.project_id
    join organization_members om
      on om.organization_id = p.organization_id
    where r.id = deliveries.return_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "deliveries_update_by_admin_or_staff"
on deliveries
for update
using (
  exists (
    select 1
    from returns r
    join projects p
      on p.id = r.project_id
    join organization_members om
      on om.organization_id = p.organization_id
    where r.id = deliveries.return_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
)
with check (
  exists (
    select 1
    from returns r
    join projects p
      on p.id = r.project_id
    join organization_members om
      on om.organization_id = p.organization_id
    where r.id = deliveries.return_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);

create policy "deliveries_delete_by_admin_or_staff"
on deliveries
for delete
using (
  exists (
    select 1
    from returns r
    join projects p
      on p.id = r.project_id
    join organization_members om
      on om.organization_id = p.organization_id
    where r.id = deliveries.return_id
      and om.user_id = auth.uid()
      and om.role in ('admin', 'staff')
  )
);
