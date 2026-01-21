begin;

with project_seed(
  id,
  team_id,
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
      'ぬいぐるみプロジェクト',
      'ハンドメイドのぬいぐるみを中心としたクラファン',
      '2025-04-01T00:00:00+09:00'::timestamptz,
      '2025-07-31T23:59:59+09:00'::timestamptz,
      2500000::numeric
    )
)
insert into projects (id, team_id, title, description, start_at, end_at, goal, created_at, updated_at)
select id, team_id, title, description, start_at, end_at, goal, now(), now()
from project_seed;

commit;
