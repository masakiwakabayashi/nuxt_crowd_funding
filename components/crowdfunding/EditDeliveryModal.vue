<script setup lang="ts">
  import { computed, ref, watch } from 'vue'
  import type { Delivery, DeliveryStatus } from '../../shared/types/Delivery'
  import type { Reward } from '../../shared/types/Rewards'

  const props = defineProps<{
    open: boolean
    delivery: Delivery
    rewards: Reward[]
  }>()

  const emit = defineEmits<{
    (e: 'close'): void
    (e: 'save', value: Delivery): void
  }>()

  const draftDelivery = ref<Delivery | null>(null)
  const completionDateMessage = ref('')
  const deliveryStatusOptions: DeliveryStatus[] = ['未着手', '作成中', '完了']

  const resetDraftDelivery = () => {
    draftDelivery.value = props.delivery
      ? { ...props.delivery, completed_at: props.delivery.completed_at ?? '' }
      : null
    completionDateMessage.value = ''
  }

  const shouldRequireCompletionDate = computed(
    () => draftDelivery.value?.status === '完了',
  )

  watch(
    () => props.delivery,
    () => {
      resetDraftDelivery()
    },
    { immediate: true },
  )

  watch(
    () => props.open,
    (isOpen) => {
      if (!isOpen) {
        resetDraftDelivery()
      }
    },
  )

  watch(
    () => draftDelivery.value?.status,
    () => {
      if (!shouldRequireCompletionDate.value) {
        completionDateMessage.value = ''
      }
    },
  )

  const handleClose = () => {
    emit('close')
  }

  const rewardNameById = (rewardId: string | null | undefined) => {
    if (!rewardId) {
      return ''
    }
    const reward = props.rewards.find((item) => item.id === rewardId)
    return reward?.title ?? ''
  }

  const validateCompletionDate = () => {
    if (shouldRequireCompletionDate.value && !draftDelivery.value?.completed_at) {
      completionDateMessage.value = 'ステータスが完了の場合は納品完了日を入力してください'
      return false
    }
    completionDateMessage.value = ''
    return true
  }

  const handleSubmit = () => {
    if (!draftDelivery.value) return
    if (!validateCompletionDate()) return
    emit('save', { ...draftDelivery.value })
    emit('close')
  }
</script>

<template>
  <Teleport to="body">
    <transition name="fade">
      <div
        v-if="open && draftDelivery"
        class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/50 px-4"
      >
        <div
          class="w-full max-w-2xl rounded-3xl bg-white p-6 shadow-2xl"
        >
          <div class="flex items-start justify-between">
            <div>
              <h3 class="text-lg font-semibold text-slate-900">
                納品情報を編集
              </h3>
              <p class="mt-1 text-sm text-slate-500">
                支援者への納品に必要な情報を更新してください。
              </p>
            </div>
            <button
              class="h-8 w-8 rounded-full text-slate-500 transition hover:bg-slate-100"
              @click="handleClose"
            >
              ×
            </button>
          </div>

          <form class="mt-6 space-y-4" @submit.prevent="handleSubmit">
            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <div class="space-y-1 text-sm">
                <span class="text-slate-600">支援者名</span>
                <p class="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-2 text-sm text-slate-700">
                  {{ draftDelivery.supporter?.name }}
                </p>
              </div>
              <div class="space-y-1 text-sm">
                <span class="text-slate-600">メールアドレス</span>
                <p class="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-2 text-sm text-slate-700">
                  {{ draftDelivery.supporter?.email }}
                </p>
              </div>
            </div>

            <div class="space-y-1 text-sm">
              <span class="text-slate-600">住所</span>
              <p class="min-h-[3rem] rounded-2xl border border-slate-200 bg-slate-50 px-4 py-2 text-sm leading-relaxed text-slate-700 whitespace-pre-line">
                {{ draftDelivery.supporter?.address }}
              </p>
            </div>

            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <div class="space-y-1 text-sm">
                <span class="text-slate-600">リターン内容</span>
                <p class="rounded-2xl border border-slate-200 bg-slate-50 px-4 py-2 text-sm text-slate-700">
                  {{ rewardNameById(draftDelivery.reward_id) }}
                </p>
              </div>
            </div>

            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">納品予定日</span>
                <input
                  v-model="draftDelivery.due_date"
                  type="text"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                />
              </label>
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">ステータス</span>
                <select
                  v-model="draftDelivery.status"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                >
                  <option
                  v-for="status in deliveryStatusOptions"
                    :key="status"
                    :value="status"
                  >
                    {{ status }}
                  </option>
                </select>
              </label>
            </div>

            <div v-if="shouldRequireCompletionDate" class="space-y-1 text-sm">
              <span class="text-slate-600">納品完了日</span>
              <input
                v-model="draftDelivery.completed_at"
                type="text"
                :class="[
                  'w-full rounded-2xl border px-4 py-2 text-sm focus:outline-none',
                  completionDateMessage
                    ? 'border-rose-300 focus:border-rose-400'
                    : 'border-slate-200 focus:border-emerald-400',
                ]"
                required
              />
              <p class="text-xs text-slate-400">
                ステータスが完了の場合のみ入力が必要です
              </p>
              <p v-if="completionDateMessage" class="text-xs text-rose-500">
                {{ completionDateMessage }}
              </p>
            </div>

            <div class="flex justify-end gap-3 pt-4">
              <button
                type="button"
                class="rounded-full border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50"
                @click="handleClose"
              >
                キャンセル
              </button>
              <button
                type="submit"
                class="rounded-full bg-gradient-to-r from-emerald-500 to-teal-500 px-6 py-2 text-sm font-semibold text-white shadow-[0_8px_16px_rgba(16,185,129,0.35)] hover:brightness-110"
              >
                保存する
              </button>
            </div>
          </form>
        </div>
      </div>
    </transition>
  </Teleport>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
