begin;

with org_seed(id, name) as (
  values
    ('b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'::uuid, 'クラフトスタジオ協同組合'),
    ('3f0be15b-63f4-40ab-9022-5c5fc70daecc'::uuid, 'グリーンフューチャー研究会')
)
insert into organizations (id, name, created_at, updated_at)
select id, name, now(), now()
from org_seed;

commit;
