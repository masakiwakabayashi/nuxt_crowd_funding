begin;

with category_seed(id, project_id, name) as (
  values
    ('5cfa7cb0-468f-4a7e-a024-3d5cdd902b04'::uuid, '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid, '素材調達'),
    ('02bd6bf1-9803-4dc0-8852-9d51a79a3ad5'::uuid, '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid, '制作工程')
)
insert into categories (id, project_id, name, created_at, updated_at)
select id, project_id, name, now(), now()
from category_seed;

commit;
