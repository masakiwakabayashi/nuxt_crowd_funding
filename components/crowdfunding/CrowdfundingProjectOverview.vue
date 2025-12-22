<script setup lang="ts">
  import type { ProjectSummary } from './types'

  const props = defineProps<{
    projectSummary: ProjectSummary
    goalProgress: number
    summaryError: Error | null | undefined
    isSummaryLoading: boolean
  }>()
</script>

<template>
  <section
    class="relative overflow-hidden rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
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

    <div class="relative z-10 space-y-6">
      <div class="space-y-4">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.35em] text-slate-400">
            プロジェクト名
          </p>
          <p class="mt-2 text-3xl font-bold text-slate-900">
            {{ props.projectSummary.name }}
          </p>
        </div>
        <div
          class="inline-flex items-center gap-2 rounded-full bg-emerald-50 px-4 py-2 text-xs font-semibold text-emerald-600"
        >
          開催期間
          <span class="text-sm font-normal text-slate-900">
            {{ props.projectSummary.period }}
          </span>
        </div>

        <p
          v-if="props.summaryError"
          class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-3 text-sm text-rose-700"
        >
          Supabaseのプロジェクト情報取得に失敗しました：{{ props.summaryError?.message }}
        </p>
        <p
          v-else-if="props.isSummaryLoading"
          class="rounded-2xl border border-dashed border-slate-200 px-4 py-3 text-xs text-slate-500"
        >
          Supabaseからプロジェクト情報を取得しています…
        </p>
      </div>

      <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <div
          class="rounded-2xl bg-slate-50/80 p-4 text-sm text-slate-600 shadow-inner shadow-white"
        >
          <p class="text-xs uppercase tracking-wide text-slate-400">Countdown</p>
          <p class="mt-2 text-xl font-semibold text-slate-900">
            残り {{ props.projectSummary.remainingDays }} 日
          </p>
          <p class="text-xs text-slate-500">終了予定日 {{ props.projectSummary.deadline }}</p>
          <div class="mt-4 h-2 w-full overflow-hidden rounded-full bg-white">
            <div
              class="h-full rounded-full bg-gradient-to-r from-emerald-400 via-teal-400 to-sky-400"
              :style="{ width: props.goalProgress + '%' }"
            >
            </div>
          </div>
          <p class="mt-2 text-xs text-slate-500">達成率 {{ props.goalProgress }}%</p>
        </div>
        <article class="rounded-2xl bg-slate-50/70 p-4 shadow-inner shadow-white">
          <p class="text-xs uppercase tracking-wide text-slate-500">全体の売り上げ</p>
          <p class="mt-2 text-2xl font-bold text-slate-900">
            ¥{{ props.projectSummary.totalSales.toLocaleString() }}
          </p>
          <p class="text-xs text-emerald-600">達成率 {{ props.goalProgress }}%</p>
        </article>
        <article class="rounded-2xl bg-slate-50/70 p-4 shadow-inner shadow-white">
          <p class="text-xs uppercase tracking-wide text-slate-500">目標金額</p>
          <p class="mt-2 text-xl font-semibold text-slate-900">
            ¥{{ props.projectSummary.goal.toLocaleString() }}
          </p>
          <p class="text-xs text-slate-500">
            残り ¥{{ props.projectSummary.remainingSales.toLocaleString() }}
          </p>
        </article>
        <article class="rounded-2xl bg-slate-50/70 p-4 shadow-inner shadow-white">
          <p class="text-xs uppercase tracking-wide text-slate-500">締切</p>
          <p class="mt-2 text-xl font-semibold text-slate-900">
            {{ props.projectSummary.deadline }}
          </p>
          <p class="text-xs text-slate-500">残り {{ props.projectSummary.remainingDays }} 日</p>
        </article>
      </div>
    </div>
  </section>
</template>
