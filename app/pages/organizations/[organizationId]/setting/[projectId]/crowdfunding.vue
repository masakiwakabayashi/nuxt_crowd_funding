<template>
  <main class="flex flex-1 flex-col gap-8 pb-16">
    <section class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70">
      <div class="flex flex-wrap items-start justify-between gap-4">
        <div>
          <p class="text-xs uppercase tracking-wide text-slate-400">
            クラウドファンディング概要
          </p>
          <h1 class="mt-1 text-2xl font-semibold text-slate-900">
            プロジェクトの基本情報
          </h1>
          <p class="mt-2 text-sm text-slate-500">
            プロジェクト名や募集期間、目標金額を編集できます。
          </p>
        </div>
        <div class="min-w-[240px]">
          <label class="text-xs font-medium text-slate-500">対象プロジェクト</label>
          <select
            v-model="selectedProjectId"
            class="mt-1 w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm text-slate-700"
            :disabled="areProjectsLoading || !projects.length"
          >
            <option value="" disabled>プロジェクトを選択</option>
            <option v-for="project in projects" :key="project.id" :value="project.id">
              {{ project.title }}
            </option>
          </select>
        </div>
      </div>

      <div v-if="selectedProject" class="mt-8 grid gap-8 lg:grid-cols-[minmax(0,1.4fr)_minmax(280px,1fr)]">
        <form class="space-y-6" @submit.prevent="handleProjectSave">
          <div>
            <label class="text-xs font-medium text-slate-500">プロジェクト名</label>
            <input
              v-model="projectForm.title"
              type="text"
              class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-3 text-base text-slate-900 focus:border-emerald-400 focus:outline-none"
              placeholder="例：地域菜園の拡張プロジェクト"
            />
          </div>

          <div>
            <label class="text-xs font-medium text-slate-500">概要</label>
            <textarea
              v-model="projectForm.description"
              rows="4"
              class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-3 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
              placeholder="プロジェクトの内容や目的を記載してください"
            />
          </div>

          <div class="grid gap-4 md:grid-cols-2">
            <div>
              <label class="text-xs font-medium text-slate-500">募集開始</label>
              <input
                v-model="projectForm.startAt"
                type="datetime-local"
                class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
              />
            </div>
            <div>
              <label class="text-xs font-medium text-slate-500">募集終了</label>
              <input
                v-model="projectForm.endAt"
                type="datetime-local"
                class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label class="text-xs font-medium text-slate-500">目標金額 (円)</label>
            <input
              v-model.number="projectForm.goal"
              type="number"
              min="0"
              step="1000"
              class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
            />
          </div>

          <div class="flex flex-wrap justify-end gap-3">
            <button
              type="button"
              class="rounded-2xl border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600"
              @click="resetProjectForm"
              :disabled="isSavingProject"
            >
              変更をリセット
            </button>
            <button
              type="submit"
              class="rounded-2xl bg-emerald-500 px-6 py-2 text-sm font-semibold text-white shadow-lg shadow-emerald-300/50 disabled:opacity-50"
              :disabled="isSavingProject"
            >
              {{ isSavingProject ? '保存中...' : '概要を更新' }}
            </button>
          </div>
        </form>

        <aside class="space-y-6">
          <article class="rounded-2xl border border-emerald-50 bg-emerald-50/60 p-5 text-sm text-slate-700">
            <p class="text-xs uppercase tracking-wide text-emerald-600">
              プロジェクト概要
            </p>
            <dl class="mt-4 space-y-3">
              <div>
                <dt class="text-xs text-slate-500">募集期間</dt>
                <dd class="mt-1 font-semibold text-slate-900">
                  {{ projectPeriodLabel }}
                </dd>
              </div>
              <div>
                <dt class="text-xs text-slate-500">現在の目標金額</dt>
                <dd class="mt-1 text-lg font-semibold text-emerald-700">
                  {{ formatCurrency(projectForm.goal) }}
                </dd>
              </div>
              <div class="grid grid-cols-2 gap-3 text-center">
                <div>
                  <p class="text-xs text-slate-500">支援者数</p>
                  <p class="mt-1 text-lg font-semibold text-slate-900">
                    {{ projectStats.totalSupporters }}
                  </p>
                </div>
                <div>
                  <p class="text-xs text-slate-500">売上見込み</p>
                  <p class="mt-1 text-lg font-semibold text-emerald-700">
                    {{ formatCurrency(projectStats.totalSales) }}
                  </p>
                </div>
              </div>
            </dl>
          </article>

          <article class="rounded-2xl border border-white/50 bg-white/60 p-5 text-xs text-slate-500">
            <dl class="space-y-3">
              <div>
                <dt>作成日時</dt>
                <dd class="mt-1 text-sm font-semibold text-slate-900">
                  {{ formatDateTime(selectedProject.createdAt) || '-' }}
                </dd>
              </div>
              <div>
                <dt>最終更新</dt>
                <dd class="mt-1 text-sm font-semibold text-slate-900">
                  {{ formatDateTime(selectedProject.updatedAt) || '-' }}
                </dd>
              </div>
            </dl>
          </article>
        </aside>
      </div>

      <p
        v-else-if="!areProjectsLoading && !projectsError"
        class="mt-6 text-sm text-slate-500"
      >
        クラウドファンディングがまだ登録されていません。組織詳細ページから先に作成してください。
      </p>

      <p v-else-if="projectsError" class="mt-6 text-sm text-rose-500">
        プロジェクト情報の取得に失敗しました。
      </p>

      <p v-else class="mt-6 text-sm text-slate-500">読み込み中...</p>
    </section>

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
          :disabled="!selectedProject || areRewardsLoading"
        >
          ＋ 新規リターン
        </button>
      </div>

      <div v-if="!selectedProject" class="mt-6 rounded-2xl border border-dashed border-slate-200 p-6 text-sm text-slate-500">
        編集するプロジェクトを先に選択してください。
      </div>

      <div v-else>
        <p v-if="areRewardsLoading" class="mt-6 text-sm text-slate-500">
          リターン情報を読み込み中です...
        </p>

        <p v-else-if="!rewardDrafts.length && !rewardsError" class="mt-6 text-sm text-slate-500">
          登録されているリターンはありません。新しいリターンを追加してください。
        </p>

        <p v-else-if="rewardsError" class="mt-6 text-sm text-rose-500">
          リターン情報の取得に失敗しました。
        </p>

        <div v-else class="mt-6 space-y-4">
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
                  <div>
                    <label class="text-xs font-medium text-slate-500">カテゴリ</label>
                    <input
                      v-model="reward.draft.category"
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
  </main>
</template>

<script setup lang="ts">
  import { computed, reactive, ref, watch } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import { useRoute, useRouter } from 'vue-router'
  import {
    formatDateTime,
    formatDisplayDate,
  } from '../../../../../../shared/utils/date'

  type OrganizationProject = {
    id: string
    title: string
    description: string | null
    startAt: string
    endAt: string
    goal: number
    createdAt: string
    updatedAt: string
  }

  type RewardRecord = {
    id: string
    projectId: string
    title: string
    description: string
    price: number
    supporters: number
    limit: number | null
    deliverySchedule: string | null
    category: string
  }

  type EditableReward = RewardRecord & {
    draft: {
      title: string
      description: string
      price: number
      limit: number | null
      deliverySchedule: string | null
      category: string
    }
    isEditing: boolean
    isNew: boolean
  }

  const route = useRoute()
  const router = useRouter()

  const organizationId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'

  const {
    data: projectsData,
    pending: areProjectsLoading,
    error: projectsError,
  } = await useAsyncData<{ projects: OrganizationProject[] }>(
    `organization-projects-${organizationId}`,
    () => $fetch(`/api/organizations/${organizationId}/projects`),
  )

  const projects = computed<OrganizationProject[]>(
    () => projectsData.value?.projects ?? [],
  )

  const initialProjectId =
    typeof route.query.projectId === 'string' ? route.query.projectId : ''

  const selectedProjectId = ref<string>(initialProjectId)

  watch(
    () => route.query.projectId,
    (projectId) => {
      if (typeof projectId === 'string' && projectId !== selectedProjectId.value) {
        selectedProjectId.value = projectId
      }
    },
  )

  watch(selectedProjectId, (projectId) => {
    const current = typeof route.query.projectId === 'string' ? route.query.projectId : ''
    const hasCurrentQuery = Boolean(current)
    if ((projectId && projectId === current) || (!projectId && !hasCurrentQuery)) {
      return
    }

    const nextQuery = { ...route.query }
    if (projectId) {
      nextQuery.projectId = projectId
    } else {
      delete nextQuery.projectId
    }

    router.replace({ query: nextQuery })
  })

  const selectedProject = computed<OrganizationProject | null>(() =>
    projects.value.find((project) => project.id === selectedProjectId.value) ?? null,
  )

  const projectForm = reactive({
    title: '',
    description: '',
    startAt: '',
    endAt: '',
    goal: 0,
  })

  const toLocalInputValue = (value: string) => {
    if (!value) return ''
    const date = new Date(value)
    if (Number.isNaN(date.getTime())) return ''
    const tzOffset = date.getTimezoneOffset()
    const adjusted = new Date(date.getTime() - tzOffset * 60 * 1000)
    return adjusted.toISOString().slice(0, 16)
  }

  const resetProjectForm = () => {
    if (!selectedProject.value) {
      projectForm.title = ''
      projectForm.description = ''
      projectForm.startAt = ''
      projectForm.endAt = ''
      projectForm.goal = 0
      return
    }

    projectForm.title = selectedProject.value.title
    projectForm.description = selectedProject.value.description ?? ''
    projectForm.startAt = toLocalInputValue(selectedProject.value.startAt)
    projectForm.endAt = toLocalInputValue(selectedProject.value.endAt)
    projectForm.goal = selectedProject.value.goal
  }

  watch(selectedProject, resetProjectForm, { immediate: true })

  const toIsoString = (value: string) => {
    if (!value) return ''
    const date = new Date(value)
    return Number.isNaN(date.getTime()) ? '' : date.toISOString()
  }

  const isSavingProject = ref(false)

  const handleProjectSave = async () => {
    if (!selectedProject.value) return
    isSavingProject.value = true

    try {
      await new Promise((resolve) => setTimeout(resolve, 600))
      console.log('update project payload', {
        id: selectedProject.value.id,
        title: projectForm.title,
        description: projectForm.description,
        startAt: toIsoString(projectForm.startAt),
        endAt: toIsoString(projectForm.endAt),
        goal: projectForm.goal,
      })
    } finally {
      isSavingProject.value = false
    }
  }

  const projectPeriodLabel = computed(() => {
    if (!projectForm.startAt || !projectForm.endAt) {
      return '未設定'
    }

    const start = formatDisplayDate(projectForm.startAt)
    const end = formatDisplayDate(projectForm.endAt)
    return `${start || '-'} 〜 ${end || '-'}`
  })

  const {
    data: rewardsData,
    pending: areRewardsLoading,
    error: rewardsError,
  } = await useAsyncData<{ rewards: RewardRecord[] }>(
    `organization-rewards-${organizationId}`,
    () =>
      $fetch('/api/crowdfunding/rewards', {
        query: { organizationId },
      }),
  )

  const rewardDrafts = ref<EditableReward[]>([])

  watch(
    [selectedProjectId, () => rewardsData.value?.rewards ?? []],
    ([projectId, rewardList]) => {
      if (!projectId) {
        rewardDrafts.value = []
        return
      }

      const filtered = (rewardList as RewardRecord[]).filter(
        (reward) => reward.projectId === projectId,
      )

      rewardDrafts.value = filtered.map((reward) => ({
        ...reward,
        draft: {
          title: reward.title,
          description: reward.description,
          price: reward.price,
          limit: reward.limit,
          deliverySchedule: reward.deliverySchedule,
          category: reward.category,
        },
        isEditing: false,
        isNew: false,
      }))
    },
    { immediate: true },
  )

  const formatCurrency = (value: number) =>
    new Intl.NumberFormat('ja-JP', {
      style: 'currency',
      currency: 'JPY',
      maximumFractionDigits: 0,
    }).format(Number.isNaN(value) ? 0 : value)

  const projectStats = computed(() => {
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

  const generateTempId = () => `${Date.now()}-${Math.random().toString(16).slice(2)}`

  const addNewReward = () => {
    if (!selectedProjectId.value) return

    rewardDrafts.value = [
      {
        id: generateTempId(),
        projectId: selectedProjectId.value,
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

  const savingRewardId = ref<string>('')

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
</script>
