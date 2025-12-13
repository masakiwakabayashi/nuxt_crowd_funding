begin;

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

commit;
