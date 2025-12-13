begin;

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

commit;
