# UI デザインガイド (Tailwind)

本ドキュメントはトップページ（`app/pages/index.vue`）をベースとしつつ、他ページも同じトーンで構築するための Tailwind CSS 指針です。必ず Tailwind ユーティリティを用いてスタイルを組み立て、カスタム CSS を追加する場合もユーティリティから逸脱しないようにしてください。

## 1. カラーパレット
| トークン | Tailwind クラス | 用途 |
| --- | --- | --- |
| `bg-base` | `bg-slate-50` / `bg-slate-100` | ページ全体の背景 |
| `surface` | `bg-white` + `shadow-[0_12px_30px_rgba(15,23,42,0.08)]` を `shadow` で再現 | セクションカード |
| `surface-alt` | `bg-indigo-50` または `bg-cyan-50` | アクセントセクション |
| `text-main` | `text-slate-900` | 主テキスト |
| `text-muted` | `text-slate-600` | 補足テキスト |
| `primary` | `bg-slate-900 text-white` (`hover:bg-slate-800`) | CTA ボタン |
| `secondary` | `bg-white/30 text-slate-900 border border-slate-900/20` | サブボタン |
| `accent` | `from-cyan-300 to-sky-500` のグラデーション | ヒーロー等の背景 |

## 2. タイポグラフィ
- 基本フォント: `font-sans` (`font-family: 'Inter', 'Hiragino Sans', 'Yu Gothic', sans-serif` を Tailwind の `@layer base` で定義済み ).
- 見出し: `text-4xl font-bold leading-snug md:text-[clamp(2rem,5vw,3.5rem)]` のようにレスポンシブ設定。
- サブコピー: `text-base leading-relaxed text-slate-600` を基準。
- Eyebrow: `text-xs uppercase tracking-[0.3em] text-slate-500`。

## 3. レイアウトパターン
1. **ページラッパ**
   ```html
   <main class="mx-auto max-w-5xl px-5 py-10 md:px-10">
   ```
   - 背景には `body` に `bg-slate-50` を適用。
2. **セクションカード**
   ```html
   <section class="mt-12 rounded-3xl bg-white p-10 shadow-xl">
   ```
   - ハイライト版は `bg-indigo-50` またはグラデーション `bg-gradient-to-br from-cyan-200 to-sky-500 text-slate-900`。
3. **レスポンシブグリッド**
   - 機能一覧: `grid gap-6 md:grid-cols-3`。
   - ステップ/カード: `flex flex-col gap-5 md:flex-row` or `grid grid-cols-1 gap-8 md:grid-cols-3`。

## 4. コンポーネント指針
### Hero
- 背景: `bg-gradient-to-br from-cyan-300 via-sky-400 to-blue-500`。
- 角丸: `rounded-[32px]`。影: `shadow-2xl shadow-cyan-500/25`。
- ボタン: `inline-flex items-center justify-center rounded-full px-6 py-3 font-semibold transition hover:-translate-y-0.5 hover:shadow-lg`。

### Feature Card
```html
<li class="rounded-2xl bg-white/90 p-6 shadow-md shadow-slate-900/10">
  <div class="text-3xl">⚡️</div>
  <h3 class="mt-4 text-xl font-semibold text-slate-900">軽量な構成</h3>
  <p class="mt-2 text-sm text-slate-600">説明文</p>
</li>
```

### Steps (タイムライン)
- `ol` に `space-y-6`。
- 各行: `flex gap-4 rounded-2xl bg-white p-6 shadow`。
- 番号: `text-sm font-semibold tracking-widest text-slate-500`。

### フォーム
- ラッパ: `space-y-4`。
- Label: `flex flex-col text-sm font-medium text-slate-700`。
- Input: `mt-2 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-slate-900 placeholder:text-slate-400 focus:border-cyan-400 focus:ring-2 focus:ring-cyan-200`。
- ボタンは primary スタイルを踏襲。

## 5. レスポンシブルール
- `md:` で 2 カラム化、`lg:` で 3 カラム表示。
- モバイルでは `text-center`, `gap-4`, `w-full` を基本にし、CTA は全幅。
- 余白: セクション間 `mt-16 md:mt-20` を推奨。

## 6. 運用 Tips
- トップページの `hero`, `feature-grid`, `steps`, `contact-form` をコンポーネント化すると複数ページで再利用しやすい。
- 新しいページも `main` 配下で同じ余白・背景を使い、必要に応じて `section` を増やすだけで OK。
- Tailwind プリセット以外の独自値が必要な場合は、`tailwind.config` にトークン追加してから使用すること。

## 7. 実装フロー例
1. `pages/{name}.vue` を作成。
2. `<main class="page">` の代わりに `main` タグへ上記ラッパクラスを付与。
3. セクションごとに `section` コンポーネントまたは `div` を作り、表のトークンをベースに色/影/角丸を設定。
4. CTA とフォーム要素は `btn` コンポーネント or Tailwind ユーティリティで統一。
5. 仕上げに `bg-gradient-to-br` などアクセントを 1 箇所以上入れると “柔らかい” 印象を維持できる。

## 8. チェックリスト
- [ ] 背景が `bg-slate-50` 系で統一されている
- [ ] 角丸 24px 以上、影ありのカード構造になっている
- [ ] テキストカラー/サイズが表のトークンと整合
- [ ] CTA ボタンが primary/secondary バリアントで統一
- [ ] モバイルで読みやすい余白 (`space-y-6`, `p-6`) が取れている
- [ ] Tailwind クラスのみでスタイリング、必要最低限のカスタム CSS しか使っていない

