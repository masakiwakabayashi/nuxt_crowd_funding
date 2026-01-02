<script setup lang="ts">
  import { computed, ref, watch } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import CrowdfundingProjectOverview from './CrowdfundingProjectOverview.vue'
  import CrowdfundingRewardList from './CrowdfundingRewardList.vue'
  import CrowdfundingDeliveryTable from './CrowdfundingDeliveryTable.vue'
  import {
    calculateRemainingDays,
    formatDisplayDate,
    formatIsoDate,
  } from '../../shared/utils/date'
  import type {
    Delivery,
    DeliveryRecord,
    DeliveryStatus,
    ProjectSummary,
    ProjectSummaryRecord,
    Reward,
    RewardRecord,
  } from './types'

  const props = defineProps<{
    organizationId: string
  }>()

  // データ取得や型定義に関する部分が全体的にごちゃついてるので、
  // このあたりを整理する





  const filterStatus = ref<DeliveryStatus | ''>('')
  const selectedProjectId = ref<string | ''>('')
  const currentPage = ref(1)
  const ITEMS_PER_PAGE = 20

  // どうやってデータを取得するのが最適だろうか？

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
    refresh: refreshDeliveries,
  } = await useAsyncData<{ deliveries: DeliveryRecord[]; total: number; page: number; limit: number }>(
    `deliveries-${props.organizationId}`,
    () =>
      $fetch('/api/deliveries', {
        query: {
          organizationId: props.organizationId,
          page: currentPage.value,
          limit: ITEMS_PER_PAGE,
          status: filterStatus.value || undefined,
          projectId: selectedProjectId.value || undefined,
        },
      }),
    { watch: [currentPage] },
  )

  watch([filterStatus, selectedProjectId], () => {
    if (currentPage.value !== 1) {
      currentPage.value = 1
    } else {
      refreshDeliveries()
    }
  })

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
        supporterAddress: delivery.supporter?.address ?? '',
        rewardName: delivery.return?.title ?? 'リターン情報なし',
        amount: Number.isNaN(price) ? null : price,
        dueDate: formatIsoDate(dueDateRaw),
        completionDate: delivery.status === '完了' ? formatIsoDate(delivery.updatedAt) : '',
        status: delivery.status,
        isOverdue,
        isDueSoon,
        overdueDays,
      }
    }),
  )

  const deliveriesTotal = computed(() => deliveriesData.value?.total ?? 0)

  watch(
    deliveriesTotal,
    (total) => {
      const maxPage = Math.max(1, Math.ceil((total ?? 0) / ITEMS_PER_PAGE))
      if (currentPage.value > maxPage) {
        currentPage.value = maxPage
      }
    },
    { immediate: true },
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

  const updateDelivery = (delivery: Delivery) => {
    console.log('update delivery', delivery)
  }
</script>

<template>
  <div class="space-y-8">
    <div
      class="space-y-8 lg:grid lg:grid-cols-[minmax(320px,1fr)_minmax(0,1.4fr)] lg:items-stretch lg:gap-8 lg:space-y-0"
    >
      <CrowdfundingProjectOverview
        :project-summary="projectSummary"
        :goal-progress="goalProgress"
        :summary-error="summaryError"
        :is-summary-loading="isSummaryLoading"
      />

      <CrowdfundingRewardList
        :rewards="rewards"
        :total-reward-sales="totalRewardSales"
        :rewards-error="rewardsError"
        :are-rewards-loading="areRewardsLoading"
      />
    </div>

    <CrowdfundingDeliveryTable
      v-model:filter-status="filterStatus"
      v-model:page="currentPage"
      :deliveries="filteredDeliveries"
      :deliveries-error="deliveriesError"
      :is-deliveries-loading="isDeliveriesLoading"
      :items-per-page="ITEMS_PER_PAGE"
      :total-deliveries="deliveriesTotal"
      @update-delivery="updateDelivery"
    />
  </div>
</template>
