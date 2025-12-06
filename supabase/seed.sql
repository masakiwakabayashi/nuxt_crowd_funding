-- Basic dataset for local development of the crowdfunding schema.
-- NOTE: organization_members seeding assumes auth.users already contains the emails listed below.

begin;

truncate table deliveries;
truncate table supporters;
truncate table returns;
truncate table categories;
truncate table projects;
truncate table organization_members;
truncate table organizations;

with org_seed(id, name) as (
  values
    ('b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'クラフトスタジオ協同組合'),
    ('3f0be15b-63f4-40ab-9022-5c5fc70daecc'::uuid, 'グリーンフューチャー研究会')
)
insert into organizations (id, name, created_at, updated_at)
select id, name, now(), now()
from org_seed;

with member_seed(email, organization_id, role) as (
  values
    ('admin@example.com', 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'admin'),
    ('staff@example.com', 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'staff'),
    ('viewer@example.com', '3f0be15b-63f4-40ab-9022-5c5fc70daecc'::uuid, 'viewer')
),
matched_users as (
  select ms.organization_id, ms.role, u.id as user_id
  from member_seed ms
  join auth.users u on u.email = ms.email
)
insert into organization_members (id, organization_id, user_id, role, created_at, updated_at)
select gen_random_uuid(), organization_id, user_id, role, now(), now()
from matched_users;

with project_seed(
  id,
  organization_id,
  title,
  description,
  start_at,
  end_at,
  goal
) as (
  values
    (
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid,
      'サステナブル3Dプリンタ家具',
      '再生素材からコミュニティ向けの家具を製作します。',
      '2025-04-01T00:00:00+09:00'::timestamptz,
      '2025-07-31T23:59:59+09:00'::timestamptz,
      2500000::numeric
    ),
    (
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '3f0be15b-63f4-40ab-9022-5c5fc70daecc'::uuid,
      '地域菜園の拡張プロジェクト',
      '遊休地を活用して地域菜園とイベントスペースを整備します。',
      '2025-03-01T00:00:00+09:00'::timestamptz,
      '2025-06-15T23:59:59+09:00'::timestamptz,
      1200000::numeric
    )
)
insert into projects (id, organization_id, title, description, start_at, end_at, goal, created_at, updated_at)
select id, organization_id, title, description, start_at, end_at, goal, now(), now()
from project_seed;

with category_seed(id, project_id, name) as (
  values
    ('5cfa7cb0-468f-4a7e-a024-3d5cdd902b04'::uuid, '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid, '素材調達'),
    ('02bd6bf1-9803-4dc0-8852-9d51a79a3ad5'::uuid, '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid, '制作工程'),
    ('1f7e7b93-2d42-4ab9-bf3a-463857c1145b'::uuid, '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid, '苗・資材'),
    ('f1bf8b68-94bb-4bb7-a582-0987a1c9bd65'::uuid, '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid, 'コミュニティイベント')
)
insert into categories (id, project_id, name, created_at, updated_at)
select id, project_id, name, now(), now()
from category_seed;

with return_seed(
  id,
  project_id,
  title,
  detail,
  max_quantity,
  category_id
) as (
  values
    (
      '9cbf9545-132b-4b65-a7c3-1de68d8dfa5a'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '限定スツール',
      '再生木材と3Dプリントを組み合わせた限定スツール。',
      50,
      '5cfa7cb0-468f-4a7e-a024-3d5cdd902b04'::uuid
    ),
    (
      '22a33722-c32c-40a3-8e3a-66b0c5733686'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '工房ワークショップ',
      'プロジェクトメンバーによる製作体験ワークショップへご招待。',
      null,
      '02bd6bf1-9803-4dc0-8852-9d51a79a3ad5'::uuid
    ),
    (
      'c8d7d996-82a6-4a09-9560-319f52f9a463'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '季節の収穫セット',
      '地域菜園で収穫した季節の野菜セットをお届け。',
      120,
      '1f7e7b93-2d42-4ab9-bf3a-463857c1145b'::uuid
    ),
    (
      '849b9a3c-1fd8-488f-8919-6aa701d89f5a'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '菜園体験デー',
      '家族で参加できる菜園作業と交流イベントをご用意。',
      30,
      'f1bf8b68-94bb-4bb7-a582-0987a1c9bd65'::uuid
    )
)
insert into returns (id, project_id, title, detail, max_quantity, category_id, created_at, updated_at)
select id, project_id, title, detail, max_quantity, category_id, now(), now()
from return_seed;

with supporter_seed(
  id,
  project_id,
  name,
  address,
  email
) as (
  values
    (
      'e3c27350-149f-4d6f-b171-1adf9ba5480d'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '田中 太郎',
      '東京都杉並区阿佐谷南 1-2-3',
      'taro@example.com'
    ),
    (
      '0c2ed864-5e5d-4e2c-89e7-f9d2d6588365'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '加藤 沙織',
      '神奈川県川崎市中原区 4-5-6',
      'saori@example.com'
    ),
    (
      'ac3070c6-5961-4d19-a7ea-7de636a7e840'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '佐藤 真司',
      '千葉県柏市若柴 7-8-9',
      'satoshi@example.com'
    ),
    (
      '0b758e5a-eb39-4349-aceb-5c0889ec76db'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '森山 亮',
      '茨城県つくば市研究学園 10-11-12',
      'moriyama@example.com'
    )
)
insert into supporters (id, project_id, name, address, email, created_at, updated_at)
select id, project_id, name, address, email, now(), now()
from supporter_seed;

with delivery_seed(id, return_id, supporter_id, status) as (
  values
    (
      'a9962003-2d85-4e31-9309-47bb829bfcd4'::uuid,
      '9cbf9545-132b-4b65-a7c3-1de68d8dfa5a'::uuid,
      'e3c27350-149f-4d6f-b171-1adf9ba5480d'::uuid,
      '作成中'
    ),
    (
      'f4dd0a16-8e4a-4b61-95d4-4b89d6985d44'::uuid,
      '9cbf9545-132b-4b65-a7c3-1de68d8dfa5a'::uuid,
      '0c2ed864-5e5d-4e2c-89e7-f9d2d6588365'::uuid,
      '未着手'
    ),
    (
      '6fdd2b3f-5a50-4c6c-9e32-1234c6c84f0e'::uuid,
      'c8d7d996-82a6-4a09-9560-319f52f9a463'::uuid,
      'ac3070c6-5961-4d19-a7ea-7de636a7e840'::uuid,
      '完了'
    ),
    (
      'f93dcdb5-2bee-4d3c-a78e-48c20a8c4ebf'::uuid,
      '849b9a3c-1fd8-488f-8919-6aa701d89f5a'::uuid,
      '0b758e5a-eb39-4349-aceb-5c0889ec76db'::uuid,
      '未着手'
    )
)
insert into deliveries (id, return_id, supporter_id, status, created_at, updated_at)
select id, return_id, supporter_id, status, now(), now()
from delivery_seed;

commit;
