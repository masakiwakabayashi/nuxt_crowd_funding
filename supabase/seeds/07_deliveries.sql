begin;

with delivery_seed(id, return_id, supporter_id, status) as (
  values
    (
      'a9962003-2d85-4e31-9309-47bb829bfcd4'::uuid,
      '9cbf9545-132b-4b65-a7c3-1de68d8dfa5a'::uuid,
      'e3c27350-149f-4d6f-b171-1adf9ba5480d'::uuid,
      '作成中'
    ),
    (
      'f4dd0a16-8e4a-4b61-95d4-4b89d6985d44'::uuid,
      '9cbf9545-132b-4b65-a7c3-1de68d8dfa5a'::uuid,
      '0c2ed864-5e5d-4e2c-89e7-f9d2d6588365'::uuid,
      '未着手'
    ),
    (
      '6fdd2b3f-5a50-4c6c-9e32-1234c6c84f0e'::uuid,
      'c8d7d996-82a6-4a09-9560-319f52f9a463'::uuid,
      'ac3070c6-5961-4d19-a7ea-7de636a7e840'::uuid,
      '完了'
    ),
    (
      'f93dcdb5-2bee-4d3c-a78e-48c20a8c4ebf'::uuid,
      '849b9a3c-1fd8-488f-8919-6aa701d89f5a'::uuid,
      '0b758e5a-eb39-4349-aceb-5c0889ec76db'::uuid,
      '未着手'
    )
)
insert into deliveries (id, return_id, supporter_id, status, created_at, updated_at)
select id, return_id, supporter_id, status, now(), now()
from delivery_seed;

commit;
