<template>
  <main class="page">
    <header class="hero">
      <p class="eyebrow">Nuxt Sample Page</p>
      <h1>はじめてのプロジェクトのたたき台</h1>
      <p>
        シンプルなコンポーネントと柔らかい配色で作ったサンプルです。テキストやレイアウトを差し替えてそのままプロジェクトのトップページとして利用できます。
      </p>
      <div class="hero-buttons">
        <NuxtLink to="#features" class="btn primary">特徴を見る</NuxtLink>
        <NuxtLink to="#contact" class="btn secondary">まずは相談</NuxtLink>
      </div>
    </header>

    <section id="features" class="section">
      <h2>主な特徴</h2>
      <ul class="feature-grid">
        <li v-for="feature in features" :key="feature.title">
          <div class="feature-icon">{{ feature.emoji }}</div>
          <h3>{{ feature.title }}</h3>
          <p>{{ feature.description }}</p>
        </li>
      </ul>
    </section>

    <section class="section light">
      <h2>導入の流れ</h2>
      <ol class="steps">
        <li v-for="step in steps" :key="step.title">
          <p class="step-number">{{ step.number }}</p>
          <div>
            <h3>{{ step.title }}</h3>
            <p>{{ step.description }}</p>
          </div>
        </li>
      </ol>
    </section>

    <section id="contact" class="section contact">
      <h2>お気軽にお問い合わせください</h2>
      <p>
        「まずは情報収集だけ」という段階でも大丈夫です。下記のフォーム例をそのまま使ってヒアリングを始められます。
      </p>
      <form class="contact-form">
        <label>
          お名前
          <input type="text" placeholder="山田 太郎" />
        </label>
        <label>
          メールアドレス
          <input type="email" placeholder="taro@example.com" />
        </label>
        <label>
          ご相談内容
          <textarea rows="4" placeholder="やりたいことや課題を自由にご記入ください"></textarea>
        </label>
        <button type="button" class="btn primary">送信イメージ</button>
      </form>
    </section>

    <footer class="footer">
      <p>© {{ new Date().getFullYear() }} Nuxt Sample Starter</p>
    </footer>
  </main>
</template>

<script setup lang="ts">
const features = [
  {
    title: '軽量な構成',
    description: 'Nuxt 3 の標準機能のみで構成しているので学習コストが低いです。',
    emoji: '⚡️'
  },
  {
    title: '柔らかい UI',
    description: '余白と角丸を活かした優しいデザインで、どの業種にも合わせやすいトーンです。',
    emoji: '🎨'
  },
  {
    title: '用途の広さ',
    description: 'CTA ボタンやフォーム、特徴リストなど基本コンポーネントを揃えています。',
    emoji: '🧩'
  }
]

const steps = [
  {
    title: 'ヒアリング',
    description: '課題感やゴールを共有しながら方向性を固めます。',
    number: '01'
  },
  {
    title: 'プロトタイプ',
    description: '本ページをベースに各種コンポーネントを差し替えて確認します。',
    number: '02'
  },
  {
    title: '公開・改善',
    description: 'Nuxt のホットリロードで素早く調整し、公開後も継続的に改善します。',
    number: '03'
  }
]
</script>

<style scoped>
:global(body) {
  font-family: 'Inter', 'Hiragino Sans', 'Yu Gothic', sans-serif;
  margin: 0;
  background: #f4f7fb;
}

.page {
  max-width: 960px;
  margin: 0 auto;
  padding: 40px 20px 64px;
}

.hero {
  text-align: center;
  padding: 80px 20px;
  background: linear-gradient(135deg, #5eead4, #3b82f6);
  border-radius: 32px;
  color: #0f172a;
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.2);
}

.eyebrow {
  text-transform: uppercase;
  letter-spacing: 0.2em;
  font-size: 0.85rem;
  margin-bottom: 16px;
  opacity: 0.8;
}

.hero h1 {
  font-size: clamp(2rem, 5vw, 3.5rem);
  margin-bottom: 16px;
}

.hero p {
  font-size: 1.05rem;
  line-height: 1.7;
}

.hero-buttons {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 32px;
  flex-wrap: wrap;
}

.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 160px;
  padding: 12px 18px;
  border-radius: 999px;
  font-weight: 600;
  text-decoration: none;
  border: 2px solid transparent;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.btn.primary {
  background: #0f172a;
  color: #fff;
  box-shadow: 0 15px 25px rgba(15, 23, 42, 0.25);
}

.btn.secondary {
  background: rgba(255, 255, 255, 0.3);
  color: #0f172a;
  border-color: rgba(15, 23, 42, 0.2);
}

.btn:hover {
  transform: translateY(-3px);
}

.section {
  margin-top: 64px;
  padding: 48px;
  background: #fff;
  border-radius: 24px;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
}

.section.light {
  background: #eef2ff;
}

.section h2 {
  margin-top: 0;
  margin-bottom: 32px;
}

.feature-grid {
  list-style: none;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 24px;
  padding: 0;
  margin: 0;
}

.feature-grid li {
  background: #f8fafc;
  border-radius: 18px;
  padding: 24px;
  border: 1px solid #e2e8f0;
}

.feature-icon {
  font-size: 2rem;
  margin-bottom: 16px;
}

.steps {
  list-style: none;
  counter-reset: steps;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.steps li {
  display: flex;
  gap: 20px;
  background: #fff;
  border-radius: 18px;
  padding: 24px;
  align-items: center;
  box-shadow: 0 10px 20px rgba(79, 70, 229, 0.15);
}

.step-number {
  font-size: 2rem;
  font-weight: 700;
  color: #4f46e5;
  margin: 0;
}

.contact {
  background: #0f172a;
  color: #f8fafc;
}

.contact-form {
  display: grid;
  gap: 16px;
  margin-top: 24px;
}

.contact-form label {
  display: flex;
  flex-direction: column;
  font-size: 0.95rem;
  gap: 8px;
}

.contact-form input,
.contact-form textarea {
  border-radius: 12px;
  border: none;
  padding: 12px;
  font-size: 1rem;
}

.contact .btn.primary {
  background: #22d3ee;
  color: #0f172a;
  border: none;
  box-shadow: none;
}

.footer {
  text-align: center;
  margin-top: 56px;
  color: #6b7280;
  font-size: 0.9rem;
}

@media (max-width: 600px) {
  .section,
  .hero {
    padding: 32px 20px;
  }

  .steps li {
    flex-direction: column;
    text-align: center;
  }
}
</style>
