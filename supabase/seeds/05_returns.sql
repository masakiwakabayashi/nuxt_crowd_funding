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
      '限定スツール',
      '再生木材と3Dプリントを組み合わせた限定スツール。',
      50,
      '5cfa7cb0-468f-4a7e-a024-3d5cdd902b04'::uuid,
      15000::numeric,
      '2025-09-01T00:00:00+09:00'::timestamptz
    ),
    (
      '22a33722-c32c-40a3-8e3a-66b0c5733686'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '工房ワークショップ',
      'プロジェクトメンバーによる製作体験ワークショップへご招待。',
      null,
      '02bd6bf1-9803-4dc0-8852-9d51a79a3ad5'::uuid,
      20000::numeric,
      '2025-10-15T00:00:00+09:00'::timestamptz
    ),
    (
      'c8d7d996-82a6-4a09-9560-319f52f9a463'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '季節の収穫セット',
      '地域菜園で収穫した季節の野菜セットをお届け。',
      120,
      '1f7e7b93-2d42-4ab9-bf3a-463857c1145b'::uuid,
      8000::numeric,
      '2025-07-15T00:00:00+09:00'::timestamptz
    ),
    (
      '849b9a3c-1fd8-488f-8919-6aa701d89f5a'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '菜園体験デー',
      '家族で参加できる菜園作業と交流イベントをご用意。',
      30,
      'f1bf8b68-94bb-4bb7-a582-0987a1c9bd65'::uuid,
      10000::numeric,
      '2025-06-20T00:00:00+09:00'::timestamptz
    )
)
insert into returns (id, project_id, title, detail, max_quantity, category_id, price, estimated_delivery, created_at, updated_at)
select id, project_id, title, detail, max_quantity, category_id, price, estimated_delivery, now(), now()
from return_seed;

commit;
