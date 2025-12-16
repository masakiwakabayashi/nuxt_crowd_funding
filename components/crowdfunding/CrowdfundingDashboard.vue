<script setup lang="ts">
  import { computed, ref } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import {
    calculateRemainingDays,
    formatDisplayDate,
    formatIsoDate,
  } from '@/shared/utils/date'
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

  const markAsCompleted = (delivery: Delivery) => {
    console.log(delivery);
  }
</script>

<template>
  <div class="space-y-8" :data-organization-id="props.organizationId">
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

    <CrowdfundingDeliveryTable
      v-model:filter-status="filterStatus"
      :deliveries="filteredDeliveries"
      :deliveries-error="deliveriesError"
      :is-deliveries-loading="isDeliveriesLoading"
      @mark-completed="markAsCompleted"
    />
  </div>
</template>
