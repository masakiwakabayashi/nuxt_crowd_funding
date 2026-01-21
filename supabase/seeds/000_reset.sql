begin;

truncate table
  deliveries,
  supporters,
  rewards,
  categories,
  projects,
  team_members,
  teams
restart identity cascade;

-- remove seeded auth users to keep re-runs idempotent
delete from auth.identities
where user_id in (
  select id from auth.users where email in (
    'admin@example.com',
    'staff@example.com',
    'viewer@example.com'
  )
);

delete from auth.users
where email in (
  'admin@example.com',
  'staff@example.com',
  'viewer@example.com'
);

commit;
