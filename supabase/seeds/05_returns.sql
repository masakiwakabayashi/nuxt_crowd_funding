begin;

with return_seed(
  id,
  project_id,
  title,
  detail,
  max_quantity,
  category_id,
  price,
  estimated_delivery
) as (
  values
    (
      '9cbf9545-132b-4b65-a7c3-1de68d8dfa5a'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      'ぬいぐるみ',
      'オリジナルキャラクターのぬいぐるみ。',
      50,
      '5cfa7cb0-468f-4a7e-a024-3d5cdd902b04'::uuid,
      15000::numeric,
      '2025-09-01T00:00:00+09:00'::timestamptz
    ),
    (
      '22a33722-c32c-40a3-8e3a-66b0c5733686'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      'キーホルダー',
      'オリジナルキャラクターのキーホルダー',
      null,
      '02bd6bf1-9803-4dc0-8852-9d51a79a3ad5'::uuid,
      20000::numeric,
      '2025-10-15T00:00:00+09:00'::timestamptz
    )
)
insert into returns (id, project_id, title, detail, max_quantity, category_id, price, estimated_delivery, created_at, updated_at)
select id, project_id, title, detail, max_quantity, category_id, price, estimated_delivery, now(), now()
from return_seed;

commit;
