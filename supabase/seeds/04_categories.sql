begin;

with category_seed(id, project_id, name) as (
  values
    ('5cfa7cb0-468f-4a7e-a024-3d5cdd902b04'::uuid, '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid, '素材調達'),
    ('02bd6bf1-9803-4dc0-8852-9d51a79a3ad5'::uuid, '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid, '制作工程'),
    ('1f7e7b93-2d42-4ab9-bf3a-463857c1145b'::uuid, '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid, '苗・資材'),
    ('f1bf8b68-94bb-4bb7-a582-0987a1c9bd65'::uuid, '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid, 'コミュニティイベント')
)
insert into categories (id, project_id, name, created_at, updated_at)
select id, project_id, name, now(), now()
from category_seed;

commit;
