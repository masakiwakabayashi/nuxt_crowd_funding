<template>
  <main class="bg-slate-50">
    <div class="mx-auto max-w-5xl px-5 py-10 md:px-10 lg:py-16">
      <header class="text-center rounded-[32px] bg-gradient-to-br from-teal-300 via-sky-400 to-blue-500 px-6 py-16 shadow-2xl shadow-slate-900/20">
        <p class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-800/80">Nuxt Sample Page</p>
        <h1 class="mt-4 text-4xl font-bold leading-snug text-slate-900 md:text-5xl">
          はじめてのプロジェクトのたたき台
        </h1>
        <p class="mt-4 text-base leading-relaxed text-slate-900/80 md:text-lg">
          シンプルなコンポーネントと柔らかい配色で作ったサンプルです。テキストやレイアウトを差し替えてそのままプロジェクトのトップページとして利用できます。
        </p>
        <div class="mt-10 flex flex-wrap items-center justify-center gap-4">
          <NuxtLink
            to="#features"
            class="inline-flex min-w-[160px] items-center justify-center rounded-full bg-slate-900 px-6 py-3 text-base font-semibold text-white shadow-lg shadow-slate-900/30 transition hover:-translate-y-0.5"
          >
            特徴を見る
          </NuxtLink>
          <NuxtLink
            to="#contact"
            class="inline-flex min-w-[160px] items-center justify-center rounded-full border border-slate-900/20 bg-white/40 px-6 py-3 text-base font-semibold text-slate-900 transition hover:-translate-y-0.5"
          >
            まずは相談
          </NuxtLink>
        </div>
      </header>

      <section id="features" class="mt-12 rounded-3xl bg-white p-10 shadow-xl">
        <h2 class="text-2xl font-semibold text-slate-900">主な特徴</h2>
        <ul class="mt-8 grid gap-6 md:grid-cols-3">
          <li
            v-for="feature in features"
            :key="feature.title"
            class="rounded-2xl bg-slate-50/70 p-6 text-left shadow-md shadow-slate-100"
          >
            <div class="text-4xl">{{ feature.emoji }}</div>
            <h3 class="mt-4 text-xl font-semibold text-slate-900">{{ feature.title }}</h3>
            <p class="mt-2 text-sm text-slate-600">{{ feature.description }}</p>
          </li>
        </ul>
      </section>

      <section class="mt-12 rounded-3xl bg-indigo-50 p-10 shadow-xl">
        <h2 class="text-2xl font-semibold text-slate-900">導入の流れ</h2>
        <ol class="mt-8 space-y-6">
          <li
            v-for="step in steps"
            :key="step.title"
            class="flex gap-5 rounded-2xl bg-white p-6 shadow"
          >
            <p class="text-sm font-semibold tracking-[0.6em] text-indigo-400">
              {{ step.number }}
            </p>
            <div>
              <h3 class="text-lg font-semibold text-slate-900">{{ step.title }}</h3>
              <p class="mt-2 text-sm text-slate-600">{{ step.description }}</p>
            </div>
          </li>
        </ol>
      </section>

      <footer class="mt-12 text-center text-sm text-slate-500">
        © {{ new Date().getFullYear() }} Nuxt Sample Starter
      </footer>
    </div>
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

