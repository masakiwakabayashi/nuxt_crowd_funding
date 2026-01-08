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
    ),
    (
      '4c1d5ce4-3a64-4dbf-8f25-583182d4c876'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '井上 彩乃',
      '東京都墨田区押上 4-2-3',
      'ayano@example.com',
      12500::numeric
    ),
    (
      'c8bde1fd-4900-42df-94a6-6c41e4a8775f'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '北村 洋平',
      '千葉県成田市並木町 5-6-7',
      'yohei@example.com',
      21000::numeric
    ),
    (
      'd9441e6c-7d00-47af-985d-9f0e457195e2'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '江口 真由',
      '神奈川県横浜市保土ケ谷区 9-10-11',
      'mayu@example.com',
      9500::numeric
    ),
    (
      '75fd382d-3920-47c8-9392-d1110ea9cd4f'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '岡野 大智',
      '東京都大田区南雪谷 11-12-13',
      'daichi.okano@example.com',
      18500::numeric
    ),
    (
      'c9a4b948-09a7-4368-9c24-933402a3887c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '吉岡 美帆',
      '東京都江戸川区小岩 2-3-4',
      'miho@example.com',
      14200::numeric
    ),
    (
      'ea3dc7ce-2dfd-4d89-b83b-4f05d9609aec'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '斎藤 亮',
      '埼玉県さいたま市岩槻区 7-8-9',
      'ryo.saito@example.com',
      16800::numeric
    ),
    (
      '0936cfdd-00c4-480e-bb14-19c9c31fb0e9'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '大森 紗月',
      '東京都渋谷区広尾 1-2-3',
      'satsuki@example.com',
      23300::numeric
    ),
    (
      '565b2ccc-e995-4f9c-9aae-c0b9b238c298'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '西田 俊介',
      '神奈川県藤沢市片瀬 4-5-6',
      'shunsuke@example.com',
      11800::numeric
    ),
    (
      '78c53d65-2f90-48cb-b47d-558b7a2c2aad'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '高島 紀子',
      '東京都中央区日本橋 7-8-9',
      'noriko@example.com',
      17500::numeric
    ),
    (
      '1f37b0df-4c02-4f55-86c0-e9662b974f42'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '池上 悠介',
      '千葉県浦安市富士見 3-4-5',
      'yusuke.ikegami@example.com',
      8900::numeric
    ),
    (
      'c1f0d27a-9cc5-415f-b5f0-9ea57ff0f0a3'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '杉山 吾郎',
      '神奈川県川崎市多摩区 6-7-8',
      'goro@example.com',
      20700::numeric
    ),
    (
      'a23a51a4-a5bb-4f07-83f1-474f36d25663'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '奈良 彩',
      '東京都練馬区石神井台 4-5-6',
      'aya.nara@example.com',
      13200::numeric
    ),
    (
      'ff9c32c6-e9b8-4537-9a59-542fe2f92498'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '南條 圭',
      '東京都中野区江古田 7-8-9',
      'kei@example.com',
      24100::numeric
    ),
    (
      'e50a4372-0bde-4d33-abe0-b2f43d63163c'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '久保田 里美',
      '東京都港区三田 5-6-7',
      'satomi@example.com',
      9600::numeric
    ),
    (
      '896679a8-bf2f-43da-b824-3d2a72eb9434'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '益田 陽介',
      '千葉県習志野市津田沼 8-9-10',
      'yosuke@example.com',
      15500::numeric
    ),
    (
      'ecd48d4e-0518-4067-80cf-053f1bc25158'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '岡崎 茜',
      '東京都世田谷区用賀 1-2-3',
      'akane@example.com',
      11200::numeric
    ),
    (
      '566defae-76a4-40f6-82d3-d63d43e7271a'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '川上 弘',
      '神奈川県大和市下鶴間 4-5-6',
      'hiroshi.kawakami@example.com',
      17800::numeric
    ),
    (
      'b8786ec6-bc21-4a12-a515-3e306fa64c5f'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '相沢 菜月',
      '東京都北区王子本町 6-7-8',
      'natsuki@example.com',
      9900::numeric
    ),
    (
      '3768aab5-3f37-4971-a1b8-ce0616966608'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '柳田 俊樹',
      '千葉県八千代市緑が丘 9-10-11',
      'toshiki@example.com',
      20100::numeric
    ),
    (
      '5596dd50-6237-40b8-8d93-4f7860695ef1'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '木戸 玲奈',
      '東京都世田谷区池尻 3-4-5',
      'rena@example.com',
      12200::numeric
    ),
    (
      '6a12cb71-31d8-463b-9e05-2c573fab71ee'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '立花 健介',
      '埼玉県草加市栄町 7-8-9',
      'kensuke@example.com',
      19000::numeric
    ),
    (
      'cd0c3f8c-5f4b-4b8d-8c62-493fd6092182'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '佐久間 梢',
      '東京都板橋区前野町 2-3-4',
      'kozue@example.com',
      8700::numeric
    ),
    (
      '0e541e4d-f06a-458a-bde4-b3571867eee2'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '黒川 凌',
      '神奈川県横浜市泉区 5-6-7',
      'ryo.kurokawa@example.com',
      16200::numeric
    ),
    (
      'a84cd4a8-6ae4-4c79-b295-cc4a805acd02'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '逢沢 凜',
      '東京都江東区有明 8-9-10',
      'rin.aizawa@example.com',
      14500::numeric
    ),
    (
      'c7acde14-2ca4-4ea6-a21f-4da155435756'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '堀田 淳也',
      '東京都品川区中延 11-12-13',
      'junya@example.com',
      23000::numeric
    ),
    (
      '254d98c7-3218-4ba0-80b0-3c3a22716803'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '岸本 杏奈',
      '東京都目黒区目黒本町 1-2-3',
      'anna@example.com',
      10200::numeric
    ),
    (
      'f8bedb34-db65-4f60-89a9-7196e74c8294'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '照井 大悟',
      '埼玉県川越市新富町 4-5-6',
      'daigo@example.com',
      21700::numeric
    ),
    (
      '268b42e0-befc-4a33-8eb4-4dfe48a6cfc9'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '二階堂 真琴',
      '東京都世田谷区成城 7-8-9',
      'makoto.nikaido@example.com',
      8800::numeric
    ),
    (
      'f04c7e22-5efd-4168-9346-98935603d00e'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '立川 直也',
      '千葉県柏市豊四季 10-11-12',
      'naoya@example.com',
      18900::numeric
    ),
    (
      '3f86bdfa-1ad4-4b64-a7fa-0a5fcb2579ce'::uuid,
      '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'::uuid,
      '樋口 悠',
      '東京都港区芝公園 2-3-4',
      'yu.higuchi@example.com',
      13800::numeric
    )
)
insert into supporters (id, project_id, name, address, email, pledged_amount, created_at, updated_at)
select id, project_id, name, address, email, pledged_amount, now(), now()
from supporter_seed;

commit;
