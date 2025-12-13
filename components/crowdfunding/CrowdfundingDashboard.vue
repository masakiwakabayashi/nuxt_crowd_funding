<script setup lang="ts">
  type ProjectSummary = {
    name: string
    period: string
    totalSales: number
    goal: number
    remainingSales: number
    remainingDays: number
    deadline: string
  }

  type ProjectSummaryRecord = {
    id: string
    title: string
    startAt: string
    endAt: string
    goal: number
    totalSales: number
    supporterCount: number
  } | null

  type DeliveryStatus = '未着手' | '作成中' | '完了'

  type DeliveryRecord = {
    id: string
    status: DeliveryStatus
    createdAt: string
    updatedAt: string
    return: {
      id: string
      projectId: string
      title: string
      detail: string | null
      maxQuantity: number | null
      categoryId: string | null
      price: string | number | null
      estimatedDelivery: string | null
    } | null
    supporter: {
      id: string
      projectId: string
      name: string
      address: string | null
      email: string | null
      pledgedAmount: string | number | null
    } | null
  }

  type Delivery = {
    id: string
    projectId: string
    supporterName: string
    supporterEmail: string
    rewardName: string
    amount: number | null
    dueDate: string
    status: DeliveryStatus
    isOverdue: boolean
    isDueSoon: boolean
    overdueDays?: number
  }

  type Reward = {
    id: string
    title: string
    description: string
    price: number
    supporters: number
    limit?: number
    deliverySchedule: string
    category: string
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

  const props = defineProps<{
    organizationId: string
  }>()

  const filterStatus = ref<DeliveryStatus | ''>('')
  const selectedProjectId = ref<string | ''>('')

  const {
    data: summaryData,
    pending: isSummaryLoading,
    error: summaryError,
  } = await useAsyncData<{ project: ProjectSummaryRecord }>(
    `crowdfunding-project-summary-${props.organizationId}`,
    () =>
      $fetch('/api/crowdfunding/project-summary', {
        query: { organizationId: props.organizationId },
      }),
  )

  const {
    data: rewardsData,
    pending: areRewardsLoading,
    error: rewardsError,
  } = await useAsyncData<{ rewards: RewardRecord[] }>(
    `crowdfunding-rewards-${props.organizationId}`,
    () =>
      $fetch('/api/crowdfunding/rewards', {
        query: { organizationId: props.organizationId },
      }),
  )

  const {
    data: deliveriesData,
    pending: isDeliveriesLoading,
    error: deliveriesError,
  } = await useAsyncData<{ deliveries: DeliveryRecord[] }>(
    `deliveries-${props.organizationId}`,
    () =>
      $fetch('/api/deliveries', {
        query: { organizationId: props.organizationId },
      }),
  )

  const formatDisplayDate = (value: string | null | undefined): string => {
    if (!value) return ''
    const date = new Date(value)
    if (Number.isNaN(date.getTime())) return ''
    const y = date.getFullYear()
    const m = String(date.getMonth() + 1).padStart(2, '0')
    const d = String(date.getDate()).padStart(2, '0')
    return `${y}/${m}/${d}`
  }

  const formatIsoDate = (value: string | null | undefined): string => {
    if (!value) return ''
    const date = new Date(value)
    return Number.isNaN(date.getTime())
      ? ''
      : date.toISOString().split('T')[0] ?? ""
  }

  const calculateRemainingDays = (
    dateString: string | null | undefined,
  ): number => {
    if (!dateString) return 0
    const deadlineDate = new Date(dateString)
    if (Number.isNaN(deadlineDate.getTime())) return 0
    const diff = deadlineDate.getTime() - Date.now()
    return Math.max(Math.ceil(diff / (1000 * 60 * 60 * 24)), 0)
  }

  const evaluateDueState = (dateString: string | null | undefined) => {
    if (!dateString) {
      return { isDueSoon: false, isOverdue: false, overdueDays: undefined }
    }

    const dueDate = new Date(dateString)
    if (Number.isNaN(dueDate.getTime())) {
      return { isDueSoon: false, isOverdue: false, overdueDays: undefined }
    }

    const diff = dueDate.getTime() - Date.now()
    const diffDays = Math.ceil(diff / (1000 * 60 * 60 * 24))

    if (diffDays < 0) {
      return {
        isDueSoon: false,
        isOverdue: true,
        overdueDays: Math.abs(diffDays),
      }
    }

    if (diffDays <= 7) {
      return { isDueSoon: true, isOverdue: false, overdueDays: undefined }
    }

    return { isDueSoon: false, isOverdue: false, overdueDays: undefined }
  }

  const deliveries = computed<Delivery[]>(() =>
    (deliveriesData.value?.deliveries ?? []).map((delivery) => {
      const projectId =
        delivery.return?.projectId ?? delivery.supporter?.projectId ?? ''
      const price = Number(delivery.return?.price ?? 0)
      const dueDateRaw =
        delivery.return?.estimatedDelivery ?? delivery.updatedAt ?? delivery.createdAt
      const { isDueSoon, isOverdue, overdueDays } = evaluateDueState(dueDateRaw)

      return {
        id: delivery.id,
        projectId,
        supporterName: delivery.supporter?.name ?? '支援者情報なし',
        supporterEmail: delivery.supporter?.email ?? '',
        rewardName: delivery.return?.title ?? 'リターン情報なし',
        amount: Number.isNaN(price) ? null : price,
        dueDate: formatIsoDate(dueDateRaw),
        status: delivery.status,
        isOverdue,
        isDueSoon,
        overdueDays,
      }
    }),
  )

  const projectSummaryFallback: ProjectSummary = {
    name: 'プロジェクト情報未取得',
    period: '-',
    totalSales: 0,
    goal: 0,
    remainingSales: 0,
    remainingDays: 0,
    deadline: '-',
  }

  const projectSummary = computed<ProjectSummary>(() => {
    const summary = summaryData.value?.project
    if (!summary) return projectSummaryFallback

    const goal = summary.goal ?? 0
    const totalSales = summary.totalSales ?? 0
    const startLabel = formatDisplayDate(summary.startAt)
    const endLabel = formatDisplayDate(summary.endAt)
    const period = startLabel && endLabel ? `${startLabel} 〜 ${endLabel}` : '-'

    return {
      name: summary.title,
      period,
      totalSales,
      goal,
      remainingSales: Math.max(goal - totalSales, 0),
      remainingDays: calculateRemainingDays(summary.endAt),
      deadline: formatIsoDate(summary.endAt) || '-',
    }
  })

  const goalProgress = computed(() => {
    const goal = projectSummary.value.goal
    if (!goal) return 0
    return Math.min(
      100,
      Math.round((projectSummary.value.totalSales / goal) * 100),
    )
  })

  const rewards = computed<Reward[]>(() =>
    (rewardsData.value?.rewards ?? []).map((reward) => ({
      id: reward.id,
      title: reward.title,
      description: reward.description,
      price: reward.price,
      supporters: reward.supporters,
      limit: reward.limit ?? undefined,
      deliverySchedule: formatDisplayDate(reward.deliverySchedule) || '-',
      category: reward.category,
    })),
  )

  const totalRewardSales = computed(() =>
    rewards.value.reduce((sum, reward) => sum + reward.price * reward.supporters, 0),
  )

  const filteredDeliveries = computed(() =>
    deliveries.value.filter((d) => {
      const matchProject =
        !selectedProjectId.value || d.projectId === selectedProjectId.value
      const matchStatus = !filterStatus.value || d.status === filterStatus.value
      return matchProject && matchStatus
    }),
  )

  const rewardSales = (reward: Reward) => reward.price * reward.supporters

  const rewardRemaining = (reward: Reward) =>
    reward.limit ? Math.max(reward.limit - reward.supporters, 0) : 0

  const rewardCapacityRate = (reward: Reward) => {
    if (!reward.limit) return 100
    if (reward.limit === 0) return 0
    return Math.min(100, Math.round((reward.supporters / reward.limit) * 100))
  }

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
        return 'bg-slate-100 text-slate-700'
      case '作成中':
        return 'bg-amber-50 text-amber-700 border border-amber-100'
      case '完了':
        return 'bg-emerald-50 text-emerald-700 border border-emerald-100'
      default:
        return 'bg-slate-100 text-slate-700'
    }
  }

  const openDetail = (delivery: Delivery) => {
    console.log('詳細を開く: ', delivery)
  }

  const markAsCompleted = (delivery: Delivery) => {
    console.log('納品完了にする: ', delivery)
    alert(`「${delivery.supporterName}」さんのリターンを完了にします（ダミー）`)
  }
</script>

<template>
  <section
    class="mb-6 rounded-2xl bg-white p-5 shadow-sm"
    :data-organization-id="props.organizationId"
  >
    <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">
          プロジェクト名
        </p>
        <p class="mt-1 text-2xl font-bold text-slate-900">
          {{ projectSummary.name }}
        </p>
      </div>
      <div class="text-sm text-slate-500">
        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">
          開催期間
        </p>
        <p class="mt-1 text-base font-semibold text-slate-800">
          {{ projectSummary.period }}
        </p>
      </div>
    </div>

    <p
      v-if="summaryError"
      class="mt-3 rounded-xl border border-rose-100 bg-rose-50 px-3 py-2 text-sm text-rose-700"
    >
      Supabaseのプロジェクト情報取得に失敗しました：{{ summaryError?.message }}
    </p>
    <p
      v-else-if="isSummaryLoading"
      class="mt-3 rounded-xl border border-dashed border-slate-200 px-3 py-2 text-xs text-slate-500"
    >
      Supabaseからプロジェクト情報を取得しています…
    </p>

    <div class="mt-4 grid gap-4 md:grid-cols-3">
      <div class="rounded-2xl bg-slate-50 p-4">
        <p class="text-xs text-slate-500">全体の売り上げ</p>
        <p class="mt-2 text-2xl font-bold text-slate-900">
          ¥{{ projectSummary.totalSales.toLocaleString() }}
        </p>
        <p class="text-xs text-emerald-600">
          達成率 {{ goalProgress }}%
        </p>
      </div>
      <div class="rounded-2xl bg-slate-50 p-4">
        <p class="text-xs text-slate-500">目標金額</p>
        <p class="mt-2 text-xl font-bold text-slate-900">
          ¥{{ projectSummary.goal.toLocaleString() }}
        </p>
        <div class="mt-3 text-sm text-slate-600">
          目標まで残り
          <span class="font-semibold text-slate-900">
            ¥{{ projectSummary.remainingSales.toLocaleString() }}
          </span>
        </div>
        <div class="mt-3 h-2 w-full overflow-hidden rounded-full bg-white">
          <div
            class="h-full rounded-full bg-emerald-500"
            :style="{ width: goalProgress + '%' }"
          />
        </div>
      </div>
      <div class="rounded-2xl bg-slate-50 p-4">
        <p class="text-xs text-slate-500">残り日数</p>
        <p class="mt-2 text-3xl font-bold text-slate-900">
          {{ projectSummary.remainingDays }}日
        </p>
        <p class="mt-1 text-xs text-slate-500">
          終了予定日 {{ projectSummary.deadline }}
        </p>
      </div>
    </div>
  </section>

  <section class="mb-6 rounded-2xl bg-white p-5 shadow-sm">
    <div
      class="mb-4 flex flex-col gap-2 md:flex-row md:items-center md:justify-between"
    >
      <div>
        <h2 class="text-sm font-semibold text-slate-700">リターン一覧</h2>
        <p class="text-xs text-slate-500">
          主要なリターン別の売り上げと支援状況を確認できます。
        </p>
      </div>
      <div class="text-right">
        <p class="text-xs text-slate-500">リターン売上合計</p>
        <p class="text-xl font-bold text-slate-900">
          ¥{{ totalRewardSales.toLocaleString() }}
        </p>
      </div>
    </div>

    <div
      v-if="rewardsError"
      class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-3 text-sm text-rose-700"
    >
      Supabaseのリターン情報取得に失敗しました：{{ rewardsError?.message }}
    </div>
    <div
      v-else-if="areRewardsLoading"
      class="flex items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 py-10 text-sm text-slate-500"
    >
      Supabaseからリターン情報を取得しています…
    </div>
    <div v-else class="grid gap-4 md:grid-cols-2">
      <article
        v-for="reward in rewards"
        :key="reward.id"
        class="rounded-2xl border border-slate-100 p-4 transition hover:border-emerald-200"
      >
        <div class="flex items-start justify-between gap-4">
          <div>
            <p class="text-xs uppercase tracking-wide text-slate-500">
              リターン
            </p>
            <h3 class="text-lg font-semibold text-slate-900">
              {{ reward.title }}
            </h3>
            <p class="mt-1 text-sm text-slate-600">
              {{ reward.description }}
            </p>
          </div>
          <div class="text-right">
            <p class="text-xs text-slate-500">価格</p>
            <p class="text-base font-semibold text-slate-900">
              ¥{{ reward.price.toLocaleString() }}
            </p>
          </div>
        </div>

        <dl class="mt-3 grid grid-cols-2 gap-2 text-sm text-slate-600 md:grid-cols-3">
          <div>
            <dt class="text-xs text-slate-500">支援者</dt>
            <dd class="text-base font-semibold text-slate-900">
              {{ reward.supporters }}人
            </dd>
          </div>
          <div>
            <dt class="text-xs text-slate-500">売り上げ</dt>
            <dd class="text-base font-semibold text-emerald-600">
              ¥{{ rewardSales(reward).toLocaleString() }}
            </dd>
          </div>
          <div class="md:text-right">
            <dt class="text-xs text-slate-500">納品目安</dt>
            <dd class="text-base font-semibold text-slate-900">
              {{ reward.deliverySchedule }}
            </dd>
          </div>
        </dl>

        <div class="mt-4 flex flex-wrap items-center gap-4 text-xs text-slate-500">
          <span>カテゴリ: {{ reward.category }}</span>
          <span v-if="reward.limit">
            残り {{ rewardRemaining(reward) }}枠 / 定員 {{ reward.limit }}
          </span>
          <span v-else>数量無制限</span>
        </div>

        <div class="mt-3 h-2 w-full overflow-hidden rounded-full bg-slate-100">
          <div
            class="h-full rounded-full bg-emerald-500"
            :style="{ width: rewardCapacityRate(reward) + '%' }"
          />
        </div>
      </article>
    </div>
  </section>

  <section class="rounded-2xl bg-white p-4 shadow-sm">
    <div class="mb-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
      <div>
        <h2 class="text-sm font-semibold text-slate-700">支援ごとの納品管理</h2>
        <div class="mt-2 flex items-center gap-2 text-xs text-slate-500">
          <span class="inline-flex h-2 w-2 rounded-full bg-rose-500" /> 期限超過
          <span class="inline-flex h-2 w-2 rounded-full bg-amber-400" /> 期限間近
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-3">
        <select
          v-model="filterStatus"
          class="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm shadow-sm"
        >
          <option value="">すべてのステータス</option>
          <option value="未着手">未着手</option>
          <option value="作成中">作成中</option>
          <option value="完了">完了</option>
        </select>
      </div>
    </div>

    <div
      v-if="deliveriesError"
      class="rounded-2xl border border-rose-100 bg-rose-50 px-4 py-3 text-sm text-rose-700"
    >
      Supabaseのデータ取得に失敗しました：{{ deliveriesError?.message }}
    </div>
    <div
      v-else-if="isDeliveriesLoading"
      class="flex items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 py-10 text-sm text-slate-500"
    >
      Supabaseからデータを取得しています…
    </div>
    <div v-else class="overflow-x-auto">
      <table class="min-w-full text-left text-sm">
        <thead>
          <tr class="border-b bg-slate-50 text-xs text-slate-500">
            <th class="px-3 py-2 font-medium">支援者</th>
            <th class="px-3 py-2 font-medium">リターン内容</th>
            <th class="px-3 py-2 font-medium">支援金額</th>
            <th class="px-3 py-2 font-medium">納品予定日</th>
            <th class="px-3 py-2 font-medium">ステータス</th>
            <th class="px-3 py-2 font-medium text-right">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="delivery in filteredDeliveries"
            :key="delivery.id"
            class="border-b last:border-0 hover:bg-slate-50/80"
          >
            <td class="px-3 py-3">
              <div class="font-medium text-slate-800">
                {{ delivery.supporterName }}
              </div>
              <div class="text-xs text-slate-500">
                {{ delivery.supporterEmail }}
              </div>
            </td>
            <td class="px-3 py-3">
              <div class="text-slate-800">
                {{ delivery.rewardName }}
              </div>
            </td>
            <td class="px-3 py-3">
              <template v-if="delivery.amount != null">
                ¥{{ delivery.amount.toLocaleString() }}
              </template>
              <span v-else class="text-slate-400">—</span>
            </td>
            <td class="px-3 py-3">
              <div class="flex items-center gap-2">
                <span
                  v-if="delivery.isOverdue"
                  class="inline-flex h-2 w-2 rounded-full bg-rose-500"
                />
                <span
                  v-else-if="delivery.isDueSoon"
                  class="inline-flex h-2 w-2 rounded-full bg-amber-400"
                />
                <span class="text-sm">
                  {{ delivery.dueDate || '—' }}
                </span>
              </div>
              <div v-if="delivery.isOverdue" class="text-xs text-rose-600">
                期限超過（{{ delivery.overdueDays }}日）
              </div>
            </td>
            <td class="px-3 py-3">
              <span
                class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-semibold"
                :class="statusBadgeClass(delivery.status)"
              >
                {{ statusLabel(delivery.status) }}
              </span>
            </td>
            <td class="px-3 py-3 text-right">
              <div class="flex justify-end gap-2">
                <button
                  class="rounded-full border border-slate-200 px-2.5 py-1 text-xs text-slate-700 hover:bg-slate-50"
                  @click="openDetail(delivery)"
                >
                  詳細
                </button>
                <button
                  class="rounded-full bg-emerald-500 px-2.5 py-1 text-xs font-semibold text-white hover:bg-emerald-600"
                  @click="markAsCompleted(delivery)"
                >
                  納品完了にする
                </button>
              </div>
            </td>
          </tr>

          <tr v-if="filteredDeliveries.length === 0">
            <td colspan="6" class="px-3 py-6 text-center text-sm text-slate-500">
              条件に一致する支援がありません。
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
