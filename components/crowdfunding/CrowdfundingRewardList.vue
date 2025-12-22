<script setup lang="ts">
  import type { Reward } from './types'

  const props = defineProps<{
    rewards: Reward[]
    totalRewardSales: number
    rewardsError: Error | null | undefined
    areRewardsLoading: boolean
  }>()

  const rewardSales = (reward: Reward) => reward.price * reward.supporters

  const rewardRemaining = (reward: Reward) =>
    reward.limit ? Math.max(reward.limit - reward.supporters, 0) : 0

  const rewardCapacityRate = (reward: Reward) => {
    if (!reward.limit) return 100
    if (reward.limit === 0) return 0
    return Math.min(100, Math.round((reward.supporters / reward.limit) * 100))
  }
</script>

<template>
  <section
    class="overflow-hidden rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
  >
    <div class="mb-6 flex flex-col gap-2">
      <div>
        <h2 class="text-base font-semibold text-slate-900">リターン一覧</h2>
        <p class="text-sm text-slate-500">
          主要なリターン別の売り上げと支援状況を確認できます。
        </p>
      </div>
      <div class="text-right">
        <p class="text-xs uppercase tracking-wide text-slate-400">
          リターン売上合計
        </p>
        <p class="text-2xl font-semibold text-slate-900">
          ¥{{ props.totalRewardSales.toLocaleString() }}
        </p>
      </div>
    </div>

    <div
      v-if="props.rewardsError"
      class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-3 text-sm text-rose-700"
    >
      Supabaseのリターン情報取得に失敗しました：{{ props.rewardsError?.message }}
    </div>
    <div
      v-else-if="props.areRewardsLoading"
      class="flex items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 py-10 text-sm text-slate-500"
    >
      Supabaseからリターン情報を取得しています…
    </div>
    <div v-else class="grid gap-6">
      <article
        v-for="reward in props.rewards"
        :key="reward.id"
        class="relative overflow-hidden rounded-3xl bg-white p-6 shadow-[0_12px_32px_rgba(15,23,42,0.08)] ring-1 ring-slate-100 transition-all duration-200 hover:-translate-y-0.5 hover:shadow-[0_24px_50px_rgba(15,23,42,0.12)]"
      >
        <div
          aria-hidden="true"
          class="pointer-events-none absolute inset-x-6 top-0 h-1 rounded-full bg-gradient-to-r from-emerald-400 via-teal-400 to-sky-400"
        >
        </div>
        <div class="flex items-start justify-between gap-4">
          <div>
            <p class="text-[11px] font-semibold uppercase tracking-[0.35em] text-slate-400">
              リターン
            </p>
            <h3 class="mt-2 text-xl font-semibold text-slate-900">
              {{ reward.title }}
            </h3>
            <p class="mt-2 text-sm leading-relaxed text-slate-600">
              {{ reward.description }}
            </p>
          </div>
          <div class="rounded-2xl bg-slate-50 px-4 py-2 text-right shadow-inner shadow-white">
            <p class="text-xs font-medium uppercase tracking-wide text-slate-500">価格</p>
            <p class="text-lg font-semibold text-slate-900">
              ¥{{ reward.price.toLocaleString() }}
            </p>
          </div>
        </div>

        <div class="mt-5 grid grid-cols-2 gap-3 text-sm text-slate-600">
          <dl class="rounded-2xl bg-slate-50/70 px-4 py-3">
            <dt class="text-[11px] font-semibold uppercase tracking-wide text-slate-500">
              支援者
            </dt>
            <dd class="mt-1 text-base font-semibold text-slate-900">
              {{ reward.supporters }}人
            </dd>
          </dl>
          <dl class="rounded-2xl bg-slate-50/70 px-4 py-3">
            <dt class="text-[11px] font-semibold uppercase tracking-wide text-slate-500">
              売り上げ
            </dt>
            <dd class="mt-1 text-base font-semibold text-emerald-600">
              ¥{{ rewardSales(reward).toLocaleString() }}
            </dd>
          </dl>
          <dl class="rounded-2xl bg-slate-50/70 px-4 py-3">
            <dt class="text-[11px] font-semibold uppercase tracking-wide text-slate-500">
              納品目安
            </dt>
            <dd class="mt-1 text-base font-semibold text-slate-900">
              {{ reward.deliverySchedule }}
            </dd>
          </dl>
        </div>

        <div class="mt-5 flex flex-wrap items-center gap-2 text-xs font-semibold text-slate-500">
          <span class="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-slate-600">
            カテゴリ: {{ reward.category }}
          </span>
          <span
            v-if="reward.limit"
            class="rounded-full border border-emerald-200 bg-emerald-50/80 px-3 py-1 text-emerald-700"
          >
            残り {{ rewardRemaining(reward) }} / 定員 {{ reward.limit }}
          </span>
          <span
            v-else
            class="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-slate-600"
          >
            数量無制限
          </span>
        </div>

        <div class="mt-5 h-1.5 w-full overflow-hidden rounded-full bg-slate-100">
          <div
            class="h-full rounded-full bg-gradient-to-r from-emerald-400 via-teal-400 to-sky-400 shadow-[0_1px_6px_rgba(16,185,129,0.45)]"
            :style="{ width: rewardCapacityRate(reward) + '%' }"
          >
          </div>
        </div>
      </article>
    </div>
  </section>
</template>
