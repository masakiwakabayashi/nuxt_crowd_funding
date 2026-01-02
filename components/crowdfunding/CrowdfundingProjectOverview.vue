<script setup lang="ts">
  import type { Project } from '../../shared/types/Project'

  const props = defineProps<{
    project: Project
  }>()
</script>

<template>
  <section
    class="relative flex h-full flex-col overflow-hidden rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
  >
    <div
      aria-hidden="true"
      class="pointer-events-none absolute -left-10 bottom-0 h-40 w-40 rounded-full bg-sky-100 blur-3xl"
    >
    </div>
    <div
      aria-hidden="true"
      class="pointer-events-none absolute right-6 top-4 h-32 w-32 rounded-full bg-emerald-100 blur-3xl"
    >
    </div>

    <div class="relative z-10 flex flex-1 flex-col space-y-6">
      <div class="space-y-4">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.35em] text-slate-400">
            プロジェクト名
          </p>
          <p class="mt-2 text-2xl font-bold text-slate-900">
            {{ props.project.title }}
          </p>
        </div>
        <div
          class="inline-flex items-center gap-2 rounded-full bg-emerald-50 px-4 py-2 text-sm font-semibold text-emerald-600"
        >
          開催期間
          <span class="text-base font-semibold text-slate-900">
            {{ props.project.start_at }} ~ {{ props.project.end_at }}
          </span>
        </div>
      </div>

      <div class="grid gap-4 sm:grid-cols-2">
        <div
          class="rounded-2xl bg-slate-50/80 p-4 text-sm text-slate-600 shadow-inner shadow-white"
        >
          <p class="text-xs uppercase tracking-wide text-slate-400">Countdown</p>
          <p class="mt-2 text-xl font-semibold text-slate-900">
            <!-- スタートとエンドの日付から残りの日数を計算する -->
            残り {{ 10 }} 日
          </p>
          <p class="text-xs text-slate-500">終了予定日 {{ props.project.end_at }}</p>
          <div class="mt-4 h-2 w-full overflow-hidden rounded-full bg-white">
            <!-- 進捗を計算する関数もつくる -->
            <div
              class="h-full rounded-full bg-gradient-to-r from-emerald-400 via-teal-400 to-sky-400"
              :style="{ width: 50 + '%' }"
            >
            </div>
          </div>
          <p class="mt-2 text-xs text-slate-500">達成率 {{ 50 }}%</p>
        </div>
        <article class="rounded-2xl bg-slate-50/70 p-4 shadow-inner shadow-white">
          <p class="text-xs uppercase tracking-wide text-slate-500">全体の売り上げ</p>
          <p class="mt-2 text-2xl font-bold text-slate-900">
            <!-- 残りの売り上げを計算する関数を作る -->
            ¥{{ 1000000 }}
          </p>
          <p class="text-xs text-emerald-600">達成率 {{ 60 }}%</p>
        </article>
        <article class="rounded-2xl bg-slate-50/70 p-4 shadow-inner shadow-white">
          <p class="text-xs uppercase tracking-wide text-slate-500">目標金額</p>
          <p class="mt-2 text-xl font-semibold text-slate-900">
            ¥{{ props.project.goal }}
          </p>
          <p class="text-xs text-slate-500">
            残り ¥{{ 50000 }}
          </p>
        </article>
        <article class="rounded-2xl bg-slate-50/70 p-4 shadow-inner shadow-white">
          <p class="text-xs uppercase tracking-wide text-slate-500">締切</p>
          <p class="mt-2 text-xl font-semibold text-slate-900">
            {{ props.project.end_at }}
          </p>
          <!-- 残りの日数を計算する関数をつくる -->
          <p class="text-xs text-slate-500">残り {{ 30 }} 日</p>
        </article>
      </div>
    </div>
  </section>
</template>
