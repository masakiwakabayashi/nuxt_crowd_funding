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
    ),
    (
      '1a0cb5f0-4bb3-4dd3-9ebf-6ab6c0f1e90c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '鈴木 花',
      '東京都目黒区中根 13-14-15',
      'hana@example.com'
    ),
    (
      '7b5f7a13-9b87-4a7e-8d3c-b1fb345afefe'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '山本 健',
      '東京都港区芝浦 2-3-4',
      'yamaken@example.com'
    ),
    (
      '33c9f144-90fb-45a1-8481-f823a58ebc2a'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '伊藤 美月',
      '神奈川県横浜市都筑区 5-6-7',
      'mizuki@example.com'
    ),
    (
      '4a59cf67-2b43-4bf5-8ec7-227aa9c1a64f'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '福田 誠',
      '埼玉県さいたま市浦和区 1-2-3',
      'makoto@example.com'
    ),
    (
      '9f00e669-b668-4341-89a1-28a741b93d7c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '藤井 里奈',
      '東京都世田谷区深沢 8-9-10',
      'rina@example.com'
    ),
    (
      'd6c9eaa7-959d-4fb7-8ea3-fa7b3b88045a'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '星野 淳',
      '千葉県船橋市海神 11-12-13',
      'hoshino@example.com'
    ),
    (
      '706d3f27-1ab1-4a1c-99f3-c5ead1bfb214'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '高木 彩',
      '茨城県水戸市見川 6-7-8',
      'aya@example.com'
    ),
    (
      '548c5fc6-6a37-4597-bd6c-4a2f0c6018d0'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '岡本 勇',
      '群馬県高崎市末広町 3-4-5',
      'isamu@example.com'
    ),
    (
      'af4b5993-ae9f-4f63-83f7-4e64afd262aa'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '西村 千夏',
      '東京都新宿区大久保 16-17-18',
      'chinatsu@example.com'
    ),
    (
      '76c76e7b-bd6a-4e76-9f69-17d24d08bf9c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '石井 徹',
      '東京都板橋区常盤台 9-10-11',
      'toru@example.com'
    ),
    (
      '6482c82d-0c61-4c00-9585-e5b62db4c0b7'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '前田 結衣',
      '神奈川県藤沢市辻堂 12-13-14',
      'yui@example.com'
    ),
    (
      '4ef9b2a8-6d14-4c7b-b33a-ccd7b032cde7'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '森内 亮太',
      '栃木県宇都宮市東峰町 7-8-9',
      'ryota@example.com'
    ),
    (
      'c2d5dafa-5181-495f-98a7-2f5d94a83b9d'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '内田 桃子',
      '東京都中野区中央 4-5-6',
      'momoko@example.com'
    ),
    (
      '518f9b10-60c2-4c5d-b317-6e7d8b3245b7'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '大西 拓真',
      '東京都練馬区豊玉 2-3-4',
      'takuma@example.com'
    ),
    (
      'fe9355aa-0e7f-4488-9d27-ea9248b721a5'::uuid,
      '9bd380be-1c2b-4f05-95a7-15bd36716577'::uuid,
      '平野 梢',
      '千葉県習志野市谷津 5-6-7',
      'kozue@example.com'
    )
)
insert into supporters (id, project_id, name, address, email, created_at, updated_at)
select id, project_id, name, address, email, now(), now()
from supporter_seed;

commit;
