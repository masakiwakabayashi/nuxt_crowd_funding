<script setup lang="ts">
  import { ref, watch } from 'vue'
  import type { Delivery, DeliveryStatus } from './types'

  const props = defineProps<{
    open: boolean
    delivery: Delivery | null
  }>()

  const emit = defineEmits<{
    (e: 'close'): void
    (e: 'save', value: Delivery): void
  }>()

  const formState = ref<Delivery | null>(null)
  const statusOptions: DeliveryStatus[] = ['未着手', '作成中', '完了']

  const syncFormState = () => {
    formState.value = props.delivery ? { ...props.delivery } : null
  }

  watch(
    () => props.delivery,
    () => {
      syncFormState()
    },
    { immediate: true },
  )

  watch(
    () => props.open,
    (isOpen) => {
      if (!isOpen) {
        syncFormState()
      }
    },
  )

  const handleClose = () => {
    emit('close')
  }

  const handleSubmit = () => {
    if (!formState.value) return
    emit('save', { ...formState.value })
    emit('close')
  }
</script>

<template>
  <Teleport to="body">
    <transition name="fade">
      <div
        v-if="open && formState"
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
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">支援者名</span>
                <input
                  v-model="formState.supporterName"
                  type="text"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                />
              </label>
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">メールアドレス</span>
                <input
                  v-model="formState.supporterEmail"
                  type="email"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                />
              </label>
            </div>

            <label class="space-y-1 text-sm">
              <span class="text-slate-600">住所</span>
              <textarea
                v-model="formState.supporterAddress"
                rows="3"
                class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
              />
            </label>

            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">リターン内容</span>
                <input
                  v-model="formState.rewardName"
                  type="text"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                />
              </label>
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">支援金額</span>
                <input
                  v-model.number="formState.amount"
                  type="number"
                  min="0"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                />
              </label>
            </div>

            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">納品予定日</span>
                <input
                  v-model="formState.dueDate"
                  type="text"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                />
              </label>
              <label class="space-y-1 text-sm">
                <span class="text-slate-600">ステータス</span>
                <select
                  v-model="formState.status"
                  class="w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm focus:border-emerald-400 focus:outline-none"
                >
                  <option
                    v-for="status in statusOptions"
                    :key="status"
                    :value="status"
                  >
                    {{ status }}
                  </option>
                </select>
              </label>
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
