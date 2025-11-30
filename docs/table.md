# クラウドファンディング納品管理SaaS テーブル定義

このドキュメントは、納品管理SaaSで利用する主要テーブルの役割とカラム定義を統一フォーマットでまとめたものです。

## テーブル一覧
| 区分 | テーブル | 役割 |
| --- | --- | --- |
| テナント/ユーザー | organizations | 利用企業・クリエイターの基本情報 |
| テナント/ユーザー | organization_members | 組織とユーザーの権限付き紐付け |
| プロジェクト/リターン | projects | クラウドファンディング案件のメタ情報 |
| プロジェクト/リターン | project_members | プロジェクト単位の担当者アサイン |
| プロジェクト/リターン | reward_tiers | リターン（コース）の定義 |
| プロジェクト/リターン | reward_variants | リターン内オプション（サイズ/カラーなど） |
| バッカー/支援 | backers | 組織単位のバッカー情報 |
| バッカー/支援 | pledges | 1件の支援（決済）を表現 |
| バッカー/支援 | pledge_items | 支援に含まれるリターンアイテム |
| 納品/進捗 | fulfillments | 納品単位の進捗管理 |
| 納品/進捗 | fulfillment_shipping | 物理配送の詳細 |
| 納品/進捗 | fulfillment_digital | デジタル納品の詳細 |

---

## 1. テナント / ユーザーまわり

### organizations（利用企業・クリエイター）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| name | text | 組織名（例: ◯◯制作スタジオ） |
| plan | text | 契約プラン。例: `free` / `pro` / `enterprise` |
| is_active | boolean | 無効化済みテナントかどうか |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

### organization_members（組織とユーザーの紐付け）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| organization_id | uuid | FK → organizations.id |
| user_id | uuid | FK → auth.users.id |
| role | text | 権限: `admin` / `staff` / `viewer` |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

---

## 2. プロジェクト / リターン定義

### projects（クラファン案件）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| organization_id | uuid | FK → organizations.id |
| name | text | プロジェクト名 |
| platform | text | 実施プラットフォーム。例: `campfire` / `makuake` |
| external_project_id | text | 外部プラットフォームID（任意） |
| project_url | text | 外部プロジェクトURL |
| start_date | date | 公開開始日 |
| end_date | date | 終了日 |
| status | text | `draft` / `active` / `closed` / `archived` |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

### project_members（プロジェクト担当者）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| project_id | uuid | FK → projects.id |
| user_id | uuid | FK → auth.users.id |
| role | text | 例: `manager` / `staff` / `viewer` |
| created_at | timestamptz | 作成日時 |

### reward_tiers（リターン/コース定義）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| project_id | uuid | FK → projects.id |
| code | text | 管理用コード（例: Aコース） |
| title | text | リターン名 |
| description | text | 詳細説明 |
| price | numeric | 支援金額 |
| type | text | `physical` / `digital` / `experience` / `other` |
| requires_shipping | boolean | 物理配送が必要か |
| estimated_delivery_date | date | 想定納品日 |
| max_backers | integer (nullable) | 上限人数 |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

### reward_variants（サイズ・カラーなどのオプション）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| reward_tier_id | uuid | FK → reward_tiers.id |
| name | text | 例: Tシャツ / Lサイズ / 白 |
| code | text | 管理コード（例: TSHIRT-L-WHITE） |
| extra_note | text | 備考 |
| created_at | timestamptz | 作成日時 |

---

## 3. バッカー / 支援情報

### backers（支援者）
外部プラットフォームからのCSVインポートを想定。個人情報管理方針に応じて組織単位またはプロジェクト単位で運用できるが、ここでは組織単位とする。

| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| organization_id | uuid | FK → organizations.id |
| name | text | 表示名 |
| email | text | メールアドレス |
| phone | text | 電話番号 |
| note | text | 内部メモ |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

### pledges（支援）
1件の支援（決済）を格納。外部IDや通貨も保持しておく。

| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| project_id | uuid | FK → projects.id |
| backer_id | uuid | FK → backers.id |
| external_pledge_id | text | 外部ID（任意） |
| pledged_amount | numeric | 支援金額 |
| currency | text | 通貨。例: JPY |
| pledged_at | timestamptz | 支援日時 |
| status | text | `confirmed` / `cancelled` / `refunded` |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

### pledge_items（支援に含まれるリターン単位）
1支援に複数リターン（コース/オプション）が含まれる想定。

| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| pledge_id | uuid | FK → pledges.id |
| reward_tier_id | uuid | FK → reward_tiers.id |
| reward_variant_id | uuid (nullable) | FK → reward_variants.id |
| quantity | integer | 個数 |
| unit_price | numeric | 当時の単価 |
| note | text | 備考（サイズ指定など） |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

---

## 4. 納品 / 進捗管理

### fulfillments（納品管理の単位）
「どの支援者に、どのリターンをどう納品したか」を一元管理。物理配送・デジタル納品どちらにも対応する。

| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| pledge_item_id | uuid | FK → pledge_items.id |
| project_id | uuid | FK → projects.id（検索用） |
| backer_id | uuid | FK → backers.id（検索用） |
| type | text | `physical` / `digital` / `experience` |
| status | text | 進捗状態（下記参照） |
| assigned_to | uuid (nullable) | FK → auth.users.id。担当者 |
| due_date | date | 目標納品日 |
| delivered_at | timestamptz (nullable) | 納品完了日時 |
| note | text | 備考 |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

**status 値の例**
- `pending`: 未着手
- `preparing`: 準備中
- `shipped` / `delivered`: 発送済み / 納品済み
- `failed`: エラー / 返送などの異常
- `cancelled`: キャンセル

### fulfillment_shipping（物理配送の詳細）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| fulfillment_id | uuid | FK → fulfillments.id |
| shipping_address_id | uuid | FK → shipping_addresses.id |
| carrier | text | 例: ヤマト / 佐川 / 日本郵便 |
| tracking_number | text | 追跡番号 |
| shipped_at | timestamptz | 出荷日時 |
| delivered_at | timestamptz | 配達完了日時 |
| shipping_status | text | `preparing` / `shipped` / `delivered` / `returned` など |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

### fulfillment_digital（デジタル納品の詳細）
| カラム | 型 | 説明 |
| --- | --- | --- |
| id | uuid | PK |
| fulfillment_id | uuid | FK → fulfillments.id |
| download_url | text | Supabase Storage または外部URL |
| access_code | text | シリアルコードなど |
| expires_at | timestamptz (nullable) | ダウンロード期限 |
| download_count | integer | ダウンロード回数 |
| last_accessed_at | timestamptz | 最終アクセス日時 |
| created_at | timestamptz | 作成日時 |
| updated_at | timestamptz | 更新日時 |

