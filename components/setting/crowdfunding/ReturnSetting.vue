<script setup lang="ts">
  import { computed, ref, watch } from 'vue'
  import { formatDisplayDate } from '../../../shared/utils/date'
  import type {
    EditableReward,
    ProjectStats,
  } from '../../../shared/types/Crowdfunding'
  import type { Reward } from '../../../shared/types/Rewards'

  const props = defineProps<{
    organizationId: string
    selectedProjectId: string
    rewards: Reward[]
  }>()

  const emit = defineEmits<{
    (e: 'update:stats', stats: ProjectStats): void
  }>()

  const rewardDrafts = ref<EditableReward[]>([])

  watch(
    () => props.rewards,
    (rewards) => {
      rewardDrafts.value = (rewards || []).map((reward) => {
        const price = Number(reward.price ?? 0)

        return {
          id: reward.id,
          projectId: reward.project_id,
          title: reward.title ?? '',
          description: reward.detail ?? '',
          price: Number.isNaN(price) ? 0 : price,
          supporters: 0,
          limit: reward.max_quantity ?? null,
          deliverySchedule: reward.estimated_delivery ?? '',
          category: reward.category_id ?? '未分類',
          draft: {
            title: reward.title ?? '',
            description: reward.detail ?? '',
            price: Number.isNaN(price) ? 0 : price,
            limit: reward.max_quantity ?? null,
            deliverySchedule: reward.estimated_delivery ?? '',
            category: reward.category_id ?? '未分類',
          },
          isEditing: false,
          isNew: false,
        }
      })
    },
    { immediate: true },
  )

  const formatCurrency = (value: number) =>
    new Intl.NumberFormat('ja-JP', {
      style: 'currency',
      currency: 'JPY',
      maximumFractionDigits: 0,
    }).format(Number.isNaN(value) ? 0 : value)

  const hasSelectedProject = computed(() => !!props.selectedProjectId)

  const generateTempId = () => `${Date.now()}-${Math.random().toString(16).slice(2)}`

  const addNewReward = () => {
    if (!props.selectedProjectId) return

    rewardDrafts.value = [
      {
        id: generateTempId(),
        projectId: props.selectedProjectId,
        title: '新規リターン',
        description: '',
        price: 0,
        supporters: 0,
        limit: null,
        deliverySchedule: '',
        category: '未分類',
        draft: {
          title: '新規リターン',
          description: '',
          price: 0,
          limit: null,
          deliverySchedule: '',
          category: '未分類',
        },
        isEditing: true,
        isNew: true,
      },
      ...rewardDrafts.value,
    ]
  }

  const openRewardEditor = (rewardId: string) => {
    rewardDrafts.value = rewardDrafts.value.map((reward) =>
      reward.id === rewardId ? { ...reward, isEditing: true } : reward,
    )
  }

  const cancelRewardEditing = (rewardId: string) => {
    const reward = rewardDrafts.value.find((item) => item.id === rewardId)
    if (!reward) return

    if (reward.isNew) {
      rewardDrafts.value = rewardDrafts.value.filter((item) => item.id !== rewardId)
      return
    }

    reward.draft = {
      title: reward.title,
      description: reward.description,
      price: reward.price,
      limit: reward.limit,
      deliverySchedule: reward.deliverySchedule,
      category: reward.category,
    }
    reward.isEditing = false
  }

  const removeReward = (rewardId: string) => {
    rewardDrafts.value = rewardDrafts.value.filter((reward) => reward.id !== rewardId)
  }

  const savingRewardId = ref('')

  const saveRewardChanges = async (rewardId: string) => {
    const reward = rewardDrafts.value.find((item) => item.id === rewardId)
    if (!reward) return

    savingRewardId.value = rewardId

    try {
      await new Promise((resolve) => setTimeout(resolve, 500))
      reward.title = reward.draft.title
      reward.description = reward.draft.description
      reward.price = reward.draft.price
      reward.limit = reward.draft.limit
      reward.deliverySchedule = reward.draft.deliverySchedule
      reward.category = reward.draft.category
      reward.isEditing = false
      reward.isNew = false
    } finally {
      savingRewardId.value = ''
    }
  }

  const isRewardSaving = (rewardId: string) => savingRewardId.value === rewardId

  const projectStats = computed<ProjectStats>(() => {
    const totalSupporters = rewardDrafts.value.reduce(
      (sum, reward) => sum + (reward.supporters || 0),
      0,
    )
    const totalSales = rewardDrafts.value.reduce(
      (sum, reward) => sum + (reward.draft.price || reward.price || 0) * (reward.supporters || 0),
      0,
    )
    return { totalSupporters, totalSales }
  })

  watch(
    projectStats,
    (stats) => {
      emit('update:stats', stats)
    },
    { immediate: true },
  )
</script>

<template>
  <section class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70">
    <div class="flex flex-wrap items-center justify-between gap-4">
      <div>
        <p class="text-xs uppercase tracking-wide text-slate-400">リターン管理</p>
        <h2 class="mt-1 text-xl font-semibold text-slate-900">リターン一覧と編集</h2>
        <p class="mt-1 text-sm text-slate-500">
          リターン名や金額、在庫上限を調整して支援プランを整えましょう。
        </p>
      </div>
      <button
        type="button"
        class="rounded-2xl border border-emerald-200 bg-emerald-500/10 px-4 py-2 text-sm font-semibold text-emerald-700 shadow-sm disabled:opacity-60"
        @click="addNewReward"
        :disabled="!hasSelectedProject"
      >
        ＋ 新規リターン
      </button>
    </div>

    <div>
      <div class="mt-6 space-y-4">
        <article
          v-for="reward in rewardDrafts"
          :key="reward.id"
          class="rounded-2xl border border-slate-100 bg-slate-50/60 p-5"
        >
          <div class="flex flex-wrap items-start justify-between gap-4">
            <div>
              <p class="text-xs uppercase tracking-wide text-slate-400">{{ reward.category }}</p>
              <h3 class="mt-1 text-lg font-semibold text-slate-900">
                {{ reward.draft.title || reward.title || '新規リターン' }}
              </h3>
              <p class="mt-1 text-sm text-slate-600">
                {{ reward.draft.description || reward.description || '説明が登録されていません。' }}
              </p>
            </div>
            <div class="text-right text-sm text-slate-500">
              <p class="text-xs uppercase tracking-wide text-slate-400">金額</p>
              <p class="text-lg font-semibold text-emerald-700">
                {{ formatCurrency(reward.draft.price || reward.price) }}
              </p>
              <p class="mt-2 text-xs text-slate-500">
                支援者 {{ reward.supporters }} 名
              </p>
            </div>
          </div>

          <div class="mt-4 border-t border-white/60 pt-4">
            <div v-if="reward.isEditing" class="space-y-4">
              <div class="grid gap-4 md:grid-cols-2">
                <div>
                  <label class="text-xs font-medium text-slate-500">リターン名</label>
                  <input
                    v-model="reward.draft.title"
                    type="text"
                    class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
                  />
                </div>
              </div>

              <div>
                <label class="text-xs font-medium text-slate-500">説明</label>
                <textarea
                  v-model="reward.draft.description"
                  rows="3"
                  class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
                />
              </div>

              <div class="grid gap-4 md:grid-cols-3">
                <div>
                  <label class="text-xs font-medium text-slate-500">金額 (円)</label>
                  <input
                    v-model.number="reward.draft.price"
                    type="number"
                    min="0"
                    step="500"
                    class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
                  />
                </div>
                <div>
                  <label class="text-xs font-medium text-slate-500">上限数</label>
                  <input
                    v-model.number="reward.draft.limit"
                    type="number"
                    min="0"
                    class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
                    placeholder="無制限"
                  />
                </div>
                <div>
                  <label class="text-xs font-medium text-slate-500">お届け予定</label>
                  <input
                    v-model="reward.draft.deliverySchedule"
                    type="date"
                    class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
                  />
                </div>
              </div>

              <div class="flex flex-wrap justify-end gap-3">
                <button
                  type="button"
                  class="rounded-2xl border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600"
                  @click="cancelRewardEditing(reward.id)"
                  :disabled="isRewardSaving(reward.id)"
                >
                  キャンセル
                </button>
                <button
                  type="button"
                  class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-2 text-sm font-medium text-rose-600"
                  @click="removeReward(reward.id)"
                  :disabled="isRewardSaving(reward.id)"
                >
                  削除
                </button>
                <button
                  type="button"
                  class="rounded-2xl bg-emerald-500 px-6 py-2 text-sm font-semibold text-white shadow-lg shadow-emerald-300/50 disabled:opacity-50"
                  @click="saveRewardChanges(reward.id)"
                  :disabled="isRewardSaving(reward.id)"
                >
                  {{ isRewardSaving(reward.id) ? '保存中…' : 'リターンを保存' }}
                </button>
              </div>
            </div>

            <div v-else class="flex flex-wrap items-center justify-between gap-3 text-sm text-slate-600">
              <div class="space-y-1">
                <p>上限: {{ reward.limit ? reward.limit + '個' : '設定なし' }}</p>
                <p>
                  お届け予定: {{ formatDisplayDate(reward.deliverySchedule) || '未設定' }}
                </p>
              </div>
                <div class="flex gap-3">
                  <button
                    type="button"
                    class="rounded-2xl border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600"
                    @click="openRewardEditor(reward.id)"
                  >
                    編集
                  </button>
                  <button
                    type="button"
                    class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-2 text-sm font-medium text-rose-600"
                    @click="removeReward(reward.id)"
                  >
                    削除
                  </button>
                </div>
              </div>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>
