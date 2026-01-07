begin;

with user_seed(id, email, password, full_name, role_label) as (
  values
    ('f2b1f308-1b93-4f08-bc76-8aaec2df4441'::uuid, 'admin@example.com', 'Password123!'::text, '管理者ユーザー', 'admin'),
    ('4fe26c59-3d0f-4b79-8ce7-72d39a2ebda1'::uuid, 'staff@example.com', 'Password123!'::text, 'スタッフユーザー', 'staff'),
    ('8f6d7de7-9a89-4abd-ab6a-ac0d5a2dd342'::uuid, 'viewer@example.com', 'Password123!'::text, 'ビューワーユーザー', 'viewer')
),
inserted_users as (
  insert into auth.users (
    id,
    instance_id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    invited_at,
    confirmation_sent_at,
    confirmation_token,
    confirmation_redirect_to,
    confirmed_at,
    recovery_sent_at,
    recovery_token,
    email_change_token_current,
    email_change_token_new,
    email_change,
    email_change_sent_at,
    email_change_confirm_status,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    created_at,
    updated_at,
    phone,
    phone_confirmed_at,
    phone_change,
    phone_change_token,
    phone_change_sent_at,
    phone_change_confirm_status,
    banned_until,
    reauthentication_token,
    reauthentication_sent_at,
    is_anonymous
  )
  select
    id,
    '00000000-0000-0000-0000-000000000000'::uuid,
    'authenticated',
    'authenticated',
    email,
    crypt(password, gen_salt('bf')),
    now(),
    now(),
    now(),
    '',
    '',
    now(),
    now(),
    '',
    '',
    '',
    '',
    now(),
    0,
    now(),
    jsonb_build_object('provider', 'email', 'providers', array['email']),
    jsonb_build_object('full_name', full_name, 'role', role_label),
    false,
    now(),
    now(),
    null,
    null,
    '',
    '',
    null,
    0,
    null,
    '',
    null,
    false
  from user_seed
  returning id, email, role_label, raw_user_meta_data
)
insert into auth.identities (
  id,
  user_id,
  identity_data,
  provider,
  provider_id,
  last_sign_in_at,
  created_at,
  updated_at,
  email
)
select
  gen_random_uuid(),
  iu.id,
  jsonb_build_object(
    'sub', iu.id::text,
    'email', iu.email,
    'email_verified', true,
    'full_name', iu.raw_user_meta_data ->> 'full_name'
  ),
  'email',
  iu.email,
  now(),
  now(),
  now(),
  iu.email
from inserted_users iu;

commit;
