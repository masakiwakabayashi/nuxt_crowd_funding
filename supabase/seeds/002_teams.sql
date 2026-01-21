begin;

with team_seed(id, name) as (
  values
    ('b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'ハンドメイド協会')
)
insert into teams (id, name, created_at, updated_at)
select id, name, now(), now()
from team_seed;

commit;
