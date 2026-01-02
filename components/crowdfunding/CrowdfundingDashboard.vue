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

  import type { Project } from '@/shared/types/Project'
  import type { Reward } from '@/shared/types/Rewards'
  import type { Delivery } from '@/shared/types/Delivery'


  const props = defineProps<{
    // オーガニゼーションのidは必要か？
    organizationId: string,
    projectId: string,
  }>()

  const filterStatus = ref<DeliveryStatus | ''>('')
  const currentPage = ref(1)
  const ITEMS_PER_PAGE = 20

  // これは使うやつ
  const project = ref<Project>();
  const deliveries = ref<Delivery[]>([]);
  const rewards = ref<Reward[]>([]);


  // 表示するデータは全てこれに置き換える
  const {
    data: data,
    pending: isLoading,
    error: error,
  } = await useAsyncData<{ project: Project }>(
    `project-${props.organizationId}`,
    () =>
      $fetch('/api/project', {
        query: { projectId: props.projectId },
      }),
  )

  // データは取得できている
  console.log(data.value);


  // この関数はモーダルに移行する、中身もちゃんと書く
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
