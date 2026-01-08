<script setup lang="ts">
  import { computed, ref, watch } from 'vue'
  import EditDeliveryModal from './EditDeliveryModal.vue'
  import type { Reward } from '../../shared/types/Rewards'
  import type { Delivery, DeliveryStatus } from '../../shared/types/Delivery'
  import { formatJapaneseDate } from '../../shared/utils/date'

  const props = defineProps<{
    projectId: string
    rewards: Reward[]
    currentPage: number
    itemsPerPage: number
  }>()

  const emit = defineEmits<{
    (e: 'update-delivery', delivery: Delivery): void
    (e: 'update:page', value: number): void
  }>()

  const isEditModalOpen = ref(false)
  const selectedDelivery = ref<Delivery | null>(null)
  const deliveries = ref<Delivery[]>([])
  const paginatedDeliveries = computed(() => deliveries.value)
  const totalDeliveries = ref(0)
  const isLoading = ref(false)
  const fetchError = ref<string | null>(null)

  interface PaginatedDeliveryResponse {
    deliveries: Delivery[]
    totalDeliveries: number
  }

  let latestFetchToken = 0

  const fetchDeliveries = async () => {
    if (!props.projectId) {
      deliveries.value = []
      totalDeliveries.value = 0
      return
    }

    const fetchId = ++latestFetchToken
    isLoading.value = true
    fetchError.value = null

    try {
      const response = await $fetch<PaginatedDeliveryResponse>('/api/deliveries', {
        query: {
          projectId: props.projectId,
          page: props.currentPage,
          itemsPerPage: props.itemsPerPage,
        },
      })

      if (fetchId !== latestFetchToken) {
        return
      }

      deliveries.value = response.deliveries || []
      totalDeliveries.value = response.totalDeliveries || 0
    } catch (error) {
      if (fetchId !== latestFetchToken) {
        return
      }

      const message = error instanceof Error ? error.message : '不明なエラーが発生しました'
      fetchError.value = message
      deliveries.value = []
      totalDeliveries.value = 0
    } finally {
      if (fetchId === latestFetchToken) {
        isLoading.value = false
      }
    }
  }

  watch(
    () => [props.projectId, props.currentPage, props.itemsPerPage],
    () => {
      fetchDeliveries()
    },
    { immediate: true },
  )

  const rewardNameById = (rewardId: string | null | undefined) => {
    if (!rewardId) {
      return '不明なリターン'
    }
    const reward = props.rewards.find((item) => item.id === rewardId)
    return reward?.title ?? '不明なリターン'
  }

  const totalPages = computed(() => {
    if (totalDeliveries.value === 0) {
      return 1
    }

    return Math.max(1, Math.ceil(totalDeliveries.value / props.itemsPerPage))
  })

  const currentRange = computed(() => {
    if (paginatedDeliveries.value.length === 0) {
      return { start: 0, end: 0 }
    }

    const start = (props.currentPage - 1) * props.itemsPerPage + 1
    const end = start + paginatedDeliveries.value.length - 1
    return { start, end }
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

  const startEditing = (delivery: Delivery) => {
    selectedDelivery.value = delivery
    isEditModalOpen.value = true
  }

  const closeEditModal = () => {
    isEditModalOpen.value = false
  }

  const saveDelivery = (delivery: Delivery) => {
    emit('update-delivery', delivery)
  }

  const goToPreviousPage = () => {
    if (props.currentPage > 1) {
      emit('update:page', props.currentPage - 1)
    }
  }

  const goToNextPage = () => {
    if (props.currentPage < totalPages.value) {
      emit('update:page', props.currentPage + 1)
    }
  }
</script>

<template>
  <section
    class="overflow-hidden rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
  >
    <div class="mb-4 flex flex-col gap-3">
      <div>
        <h2 class="text-base font-semibold text-slate-900">支援ごとの納品管理</h2>
      </div>
    </div>

    <div
      class="overflow-x-auto rounded-3xl bg-white shadow-[0_12px_32px_rgba(15,23,42,0.08)] ring-1 ring-slate-100"
    >
      <table class="min-w-full w-full table-auto text-left text-sm text-slate-700">
        <thead>
          <tr class="border-b border-slate-100 bg-slate-50/80 text-[11px] font-semibold uppercase tracking-[0.25em] text-slate-500">
            <th class="w-[10%] px-6 py-4 font-semibold">ID</th>
            <th class="w-[20%] px-6 py-4 font-semibold">支援者</th>
            <th class="w-[20%] px-6 py-4 font-semibold">住所</th>
            <th class="w-[25%] px-6 py-4 font-semibold">リターン内容</th>
            <th class="w-[18%] px-6 py-4 font-semibold whitespace-nowrap">納品予定日</th>
            <th class="w-[12%] px-6 py-4 font-semibold">ステータス</th>
            <th class="w-[13%] px-6 py-4 text-right font-semibold">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(delivery, index) in paginatedDeliveries"
            :key="delivery.id"
            class="border-b border-slate-100 transition-colors last:border-0 hover:bg-emerald-50/40"
          >
            <td class="w-[10%] px-6 py-5 align-top">
              <div class="font-mono text-xs font-semibold text-slate-500 break-all">
                {{ (props.currentPage - 1) * props.itemsPerPage + index + 1 }}
              </div>
            </td>
            <td class="w-[20%] px-6 py-5">
              <div class="font-semibold text-slate-900">
                {{ delivery.supporter?.name }}
              </div>
              <div class="text-xs text-slate-500">
                {{ delivery.supporter?.email }}
              </div>
            </td>
            <td class="w-[20%] px-6 py-5 text-slate-900">
              <div class="text-sm leading-relaxed" :class="{ 'text-slate-400': !delivery.supporter?.address }">
                {{ delivery.supporter?.address }}
              </div>
            </td>
            <td class="w-[25%] px-6 py-5 text-slate-900">
              {{ rewardNameById(delivery.reward_id) }}
            </td>
            <td class="w-[18%] px-6 py-5 whitespace-nowrap">
              {{ formatJapaneseDate(delivery.due_date) || '未設定' }}
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
                @click="startEditing(delivery)"
              >
                編集
              </button>
            </td>
          </tr>

          <tr v-if="isLoading">
            <td colspan="8" class="px-6 py-8 text-center text-sm text-slate-500">
              読み込み中です...
            </td>
          </tr>
          <tr v-else-if="fetchError">
            <td colspan="8" class="px-6 py-8 text-center text-sm text-rose-500">
              データの取得に失敗しました: {{ fetchError }}
            </td>
          </tr>
          <tr v-else-if="paginatedDeliveries.length === 0">
            <td colspan="8" class="px-6 py-8 text-center text-sm text-slate-500">
              条件に一致する支援がありません。
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div
      v-if="totalDeliveries > 0"
      class="mt-4 flex flex-col gap-3 text-sm text-slate-600 sm:flex-row sm:items-center sm:justify-between"
    >
      <p>
        全{{ totalDeliveries }}件中
        {{ currentRange.start }}〜{{ currentRange.end }}件を表示
      </p>
      <div class="flex items-center gap-3">
        <button
          class="rounded-full border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-40"
          :disabled="props.currentPage === 1"
          @click="goToPreviousPage"
        >
          前へ
        </button>
        <span class="text-xs font-semibold text-slate-500">
          {{ props.currentPage }} / {{ totalPages }}
        </span>
        <button
          class="rounded-full border border-slate-200 px-4 py-2 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-40"
          :disabled="props.currentPage === totalPages"
          @click="goToNextPage"
        >
          次へ
        </button>
      </div>
    </div>

    <EditDeliveryModal
      v-if="selectedDelivery"
      :open="isEditModalOpen"
      :delivery="selectedDelivery"
      :rewards="rewards"
      @close="closeEditModal"
      @save="saveDelivery"
    />
  </section>
</template>
