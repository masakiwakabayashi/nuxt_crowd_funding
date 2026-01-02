begin;

with org_seed(id, name) as (
  values
    ('b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'ハンドメイド協会')
)
insert into organizations (id, name, created_at, updated_at)
select id, name, now(), now()
from org_seed;

commit;
