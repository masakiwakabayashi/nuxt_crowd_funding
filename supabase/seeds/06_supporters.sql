begin;

with supporter_seed(
  id,
  project_id,
  name,
  address,
  email,
  pledged_amount
) as (
  values
    (
      'e3c27350-149f-4d6f-b171-1adf9ba5480d'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '田中 太郎',
      '東京都杉並区阿佐谷南 1-2-3',
      'taro@example.com',
      45000::numeric
    ),
    (
      '0c2ed864-5e5d-4e2c-89e7-f9d2d6588365'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '加藤 沙織',
      '神奈川県川崎市中原区 4-5-6',
      'saori@example.com',
      12000::numeric
    ),
    (
      '1a0cb5f0-4bb3-4dd3-9ebf-6ab6c0f1e90c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '鈴木 花',
      '東京都目黒区中根 13-14-15',
      'hana@example.com',
      30000::numeric
    ),
    (
      '7b5f7a13-9b87-4a7e-8d3c-b1fb345afefe'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '山本 健',
      '東京都港区芝浦 2-3-4',
      'yamaken@example.com',
      15000::numeric
    ),
    (
      '9f00e669-b668-4341-89a1-28a741b93d7c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '藤井 里奈',
      '東京都世田谷区深沢 8-9-10',
      'rina@example.com',
      22000::numeric
    ),
    (
      'd6c9eaa7-959d-4fb7-8ea3-fa7b3b88045a'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '星野 淳',
      '千葉県船橋市海神 11-12-13',
      'hoshino@example.com',
      14000::numeric
    ),
    (
      'af4b5993-ae9f-4f63-83f7-4e64afd262aa'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '西村 千夏',
      '東京都新宿区大久保 16-17-18',
      'chinatsu@example.com',
      25000::numeric
    ),
    (
      '76c76e7b-bd6a-4e76-9f69-17d24d08bf9c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '石井 徹',
      '東京都板橋区常盤台 9-10-11',
      'toru@example.com',
      17000::numeric
    ),
    (
      'c2d5dafa-5181-495f-98a7-2f5d94a83b9d'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '内田 桃子',
      '東京都中野区中央 4-5-6',
      'momoko@example.com',
      8000::numeric
    ),
    (
      '518f9b10-60c2-4c5d-b317-6e7d8b3245b7'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '大西 拓真',
      '東京都練馬区豊玉 2-3-4',
      'takuma@example.com',
      21000::numeric
    ),
    (
      '982ad175-afd5-4066-9ea0-25500a1e6dcd'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '中村 悠人',
      '東京都豊島区巣鴨 1-2-3',
      'yuto@example.com',
      18000::numeric
    ),
    (
      '298eba7e-6bb1-4148-9808-6a9bfaead8ff'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '堀内 美沙',
      '神奈川県川崎市宮前区 5-6-7',
      'misa.h@example.com',
      9000::numeric
    ),
    (
      '6159be03-0204-4905-a6e6-8b29b46e4db0'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '吉田 一真',
      '埼玉県川口市本町 8-9-10',
      'kazuma@example.com',
      16000::numeric
    ),
    (
      '97ffbc64-d509-4571-a11c-4c6c71ecb59c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '川村 美佳',
      '千葉県松戸市馬橋 2-3-4',
      'mika@example.com',
      12500::numeric
    ),
    (
      'a57ab4f8-0971-44b2-8d80-364fab1f95f7'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '近藤 直樹',
      '東京都品川区大井 6-7-8',
      'naoki@example.com',
      22000::numeric
    ),
    (
      '85a7cb79-30bb-4b63-974b-2ad02b301864'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '柴田 梨沙',
      '東京都世田谷区砧 3-4-5',
      'risa@example.com',
      10500::numeric
    ),
    (
      '74a69cf7-86a9-4e53-9b17-c1421ec48b30'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '秋山 俊平',
      '神奈川県相模原市南区 9-10-11',
      'shunpei@example.com',
      14000::numeric
    ),
    (
      'f12163ee-8523-406d-9120-d0af085deafa'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '村上 純',
      '東京都江東区森下 12-13-14',
      'jun@example.com',
      19500::numeric
    ),
    (
      '5bbd817b-0133-4046-abdc-124e5056a1cf'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '片岡 真帆',
      '千葉県流山市西初石 5-6-7',
      'maho@example.com',
      11000::numeric
    ),
    (
      'dfa08615-f25d-42b4-a03c-554b01fb28a1'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '松永 誠司',
      '東京都台東区根岸 2-3-4',
      'seiji@example.com',
      17500::numeric
    ),
    (
      '100fa744-feea-423b-b0a0-d62e5c6ff5a9'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '青木 香織',
      '東京都江戸川区船堀 7-8-9',
      'kaori@example.com',
      9000::numeric
    ),
    (
      'ec469829-bc65-473e-98c1-2ef5b2a2e1b5'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '武田 大地',
      '埼玉県越谷市レイクタウン 10-11-12',
      'daichi@example.com',
      13000::numeric
    ),
    (
      '567258ce-5d09-40cc-9394-1f90693779eb'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '大塚 あやめ',
      '東京都文京区千駄木 4-5-6',
      'ayame@example.com',
      15000::numeric
    ),
    (
      'e38561a0-a0bb-4082-8985-980148cd3f32'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '藤田 弘樹',
      '神奈川県鎌倉市御成町 1-2-3',
      'hiroki@example.com',
      20000::numeric
    ),
    (
      '2fbebb76-1788-46a0-9622-cab57587ff10'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '菅原 さき',
      '千葉県市川市八幡 6-7-8',
      'saki@example.com',
      8500::numeric
    ),
    (
      'dc30f555-b8c2-401e-a9e3-30da0a9c9aea'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '本田 祐介',
      '東京都練馬区春日町 9-10-11',
      'yusuke@example.com',
      14500::numeric
    ),
    (
      '544dd5c5-9b26-4aae-8b05-2e00b21c5338'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '谷口 亜美',
      '東京都北区十条 3-4-5',
      'ami@example.com',
      11500::numeric
    ),
    (
      '2f4b0bc0-c4bf-4fd8-aecf-845d86b2dd36'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '小原 圭吾',
      '神奈川県横浜市金沢区 2-3-4',
      'keigo@example.com',
      21000::numeric
    ),
    (
      '906e73c2-d793-4a3e-90d3-34912fb2003e'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '白石 渚',
      '東京都杉並区高円寺南 5-6-7',
      'nagisa@example.com',
      9500::numeric
    ),
    (
      'f1363f7a-8eea-4076-8890-a8e10059d7ae'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '森岡 剛',
      '東京都足立区千住 8-9-10',
      'tsuyoshi@example.com',
      18500::numeric
    )
)
insert into supporters (id, project_id, name, address, email, pledged_amount, created_at, updated_at)
select id, project_id, name, address, email, pledged_amount, now(), now()
from supporter_seed;

commit;
