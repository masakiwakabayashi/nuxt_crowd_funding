begin;

with supporter_seed(
  id,
  project_id,
  name,
  address,
  email
) as (
  values
    (
      'e3c27350-149f-4d6f-b171-1adf9ba5480d'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '田中 太郎',
      '東京都杉並区阿佐谷南 1-2-3',
      'taro@example.com'
    ),
    (
      '0c2ed864-5e5d-4e2c-89e7-f9d2d6588365'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '加藤 沙織',
      '神奈川県川崎市中原区 4-5-6',
      'saori@example.com'
    ),
    (
      'ac3070c6-5961-4d19-a7ea-7de636a7e840'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '佐藤 真司',
      '千葉県柏市若柴 7-8-9',
      'satoshi@example.com'
    ),
    (
      '0b758e5a-eb39-4349-aceb-5c0889ec76db'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '森山 亮',
      '茨城県つくば市研究学園 10-11-12',
      'moriyama@example.com'
    )
)
insert into supporters (id, project_id, name, address, email, created_at, updated_at)
select id, project_id, name, address, email, now(), now()
from supporter_seed;

commit;
