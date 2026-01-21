begin;

with member_seed(email, team_id, role) as (
  values
    ('admin@example.com', 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'admin'),
    ('staff@example.com', 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'staff'),
    ('viewer@example.com', 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'viewer')
),
matched_users as (
  select ms.team_id, ms.role, u.id as user_id
  from member_seed ms
  join auth.users u on u.email = ms.email
)
insert into team_members (id, team_id, user_id, role, created_at, updated_at)
select gen_random_uuid(), team_id, user_id, role, now(), now()
from matched_users;

commit;
