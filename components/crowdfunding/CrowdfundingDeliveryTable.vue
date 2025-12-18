<script setup lang="ts">
  import { computed } from 'vue'
  import type { Delivery, DeliveryStatus } from './types'

  const props = defineProps<{
    filterStatus: DeliveryStatus | ''
    deliveries: Delivery[]
    deliveriesError: Error | null | undefined
    isDeliveriesLoading: boolean
  }>()

  const emit = defineEmits<{
    (e: 'update:filterStatus', value: DeliveryStatus | ''): void
    (e: 'mark-completed', delivery: Delivery): void
  }>()

  const filterStatusModel = computed({
    get: () => props.filterStatus,
    set: (value) => emit('update:filterStatus', value as DeliveryStatus | ''),
  })

  const statusLabel = (status: DeliveryStatus | '') => {
    switch (status) {
      case '未着手':
      case '作成中':
      case '完了':
        return status
      default:
        return '不明'
    }
  }

  const statusBadgeClass = (status: DeliveryStatus) => {
    switch (status) {
      case '未着手':
        return 'bg-slate-100 text-slate-700 ring-1 ring-slate-200'
      case '作成中':
        return 'bg-amber-50 text-amber-700 ring-1 ring-amber-200'
      case '完了':
        return 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200'
      default:
        return 'bg-slate-100 text-slate-700 ring-1 ring-slate-200'
    }
  }

  const markAsCompleted = (delivery: Delivery) => {
    emit('mark-completed', delivery)
  }
</script>

<template>
  <section
    class="overflow-hidden rounded-[32px] border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
  >
    <div class="mb-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
      <div>
        <h2 class="text-base font-semibold text-slate-900">支援ごとの納品管理</h2>
        <div class="mt-2 flex items-center gap-3 text-xs text-slate-500">
          <span class="inline-flex h-2 w-2 rounded-full bg-rose-500" /> 期限超過
          <span class="inline-flex h-2 w-2 rounded-full bg-amber-400" /> 期限間近
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-3">
        <select
          v-model="filterStatusModel"
          class="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm focus:border-emerald-400 focus:outline-none"
        >
          <option value="">すべてのステータス</option>
          <option value="未着手">未着手</option>
          <option value="作成中">作成中</option>
          <option value="完了">完了</option>
        </select>
      </div>
    </div>

    <div
      v-if="props.deliveriesError"
      class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-3 text-sm text-rose-700"
    >
      Supabaseのデータ取得に失敗しました：{{ props.deliveriesError?.message }}
    </div>
    <div
      v-else-if="props.isDeliveriesLoading"
      class="flex items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 py-10 text-sm text-slate-500"
    >
      Supabaseからデータを取得しています…
    </div>
    <div
      v-else
      class="overflow-x-auto rounded-[28px] bg-white shadow-[0_12px_32px_rgba(15,23,42,0.08)] ring-1 ring-slate-100"
    >
      <table class="min-w-full w-full table-auto text-left text-sm text-slate-700">
        <thead>
          <tr class="border-b border-slate-100 bg-slate-50/80 text-[11px] font-semibold uppercase tracking-[0.25em] text-slate-500">
            <th class="w-[20%] px-6 py-4 font-semibold">支援者</th>
            <th class="w-[25%] px-6 py-4 font-semibold">リターン内容</th>
            <th class="w-[12%] px-6 py-4 font-semibold whitespace-nowrap">支援金額</th>
            <th class="w-[18%] px-6 py-4 font-semibold whitespace-nowrap">納品予定日</th>
            <th class="w-[12%] px-6 py-4 font-semibold">ステータス</th>
            <th class="w-[13%] px-6 py-4 text-right font-semibold">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="delivery in props.deliveries"
            :key="delivery.id"
            class="border-b border-slate-100 transition-colors last:border-0 hover:bg-emerald-50/40"
          >
            <td class="w-[20%] px-6 py-5">
              <div class="font-semibold text-slate-900">
                {{ delivery.supporterName }}
              </div>
              <div class="text-xs text-slate-500">
                {{ delivery.supporterEmail }}
              </div>
            </td>
            <td class="w-[25%] px-6 py-5 text-slate-900">
              {{ delivery.rewardName }}
            </td>
            <td class="w-[12%] px-6 py-5 whitespace-nowrap">
              <template v-if="delivery.amount != null">
                ¥{{ delivery.amount.toLocaleString() }}
              </template>
              <span v-else class="text-slate-400">—</span>
            </td>
            <td class="w-[18%] px-6 py-5 whitespace-nowrap">
              <div class="flex items-center gap-2">
                <span
                  v-if="delivery.isOverdue"
                  class="inline-flex h-2 w-2 rounded-full bg-rose-500"
                >
                </span>
                <span
                  v-else-if="delivery.isDueSoon"
                  class="inline-flex h-2 w-2 rounded-full bg-amber-400"
                >
                </span>
                <span class="text-sm font-medium text-slate-800">
                  {{ delivery.dueDate || '—' }}
                </span>
              </div>
              <div v-if="delivery.isOverdue" class="text-xs text-rose-600">
                期限超過（{{ delivery.overdueDays }}日）
              </div>
            </td>
            <td class="w-[12%] px-6 py-5">
              <span
                class="inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold shadow-sm"
                :class="statusBadgeClass(delivery.status)"
              >
                {{ statusLabel(delivery.status) }}
              </span>
            </td>
            <td class="w-[13%] px-6 py-5 text-right">
              <button
                class="rounded-full bg-gradient-to-r from-emerald-500 to-teal-500 px-4 py-2 text-xs font-semibold text-white shadow-[0_8px_16px_rgba(16,185,129,0.35)] transition hover:brightness-110"
                @click="markAsCompleted(delivery)"
              >
                納品完了にする
              </button>
            </td>
          </tr>

          <tr v-if="props.deliveries.length === 0">
            <td colspan="6" class="px-6 py-8 text-center text-sm text-slate-500">
              条件に一致する支援がありません。
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
