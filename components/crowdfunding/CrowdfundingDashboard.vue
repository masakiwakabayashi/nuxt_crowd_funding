<script setup lang="ts">
  import { ref, watchEffect } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import CrowdfundingProjectOverview from './CrowdfundingProjectOverview.vue'
  import CrowdfundingRewardList from './CrowdfundingRewardList.vue'
  import CrowdfundingDeliveryTable from './CrowdfundingDeliveryTable.vue'
  import {
    calculateRemainingDays,
    formatDisplayDate,
    formatIsoDate,
  } from '../../shared/utils/date'

  import type { Project } from '../../shared/types/Project'
  import type { Reward } from '../../shared/types/Rewards'
  import type { Delivery } from '../../shared/types/Delivery'

  const props = defineProps<{
    organizationId: string,
    projectId: string,
  }>()

  const currentPage = ref(1)
  const ITEMS_PER_PAGE = 20

  // これは使うやつ
  const project = ref<Project>()
  const deliveries = ref<Delivery[]>([])
  const rewards = ref<Reward[]>([])


  // 表示するデータは全てこれに置き換える
  const {
    data,
    pending: isLoading,
    error,
  } = await useAsyncData<Project>(
    `project-${props.organizationId}`,
    () =>
      // あとでページネーションを考慮した取得の仕方に変える
      $fetch('/api/project', {
        query: { projectId: props.projectId },
      }),
  )

  watchEffect(() => {
    const fetchedProject = data.value
    if (!fetchedProject) return

    project.value = fetchedProject
    deliveries.value = fetchedProject.deliveries ?? []
    rewards.value = fetchedProject.rewards ?? []
  })

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
        v-if="project"
        :project="project"
      />

      <CrowdfundingRewardList
        v-if="rewards.length > 0"
        :rewards="rewards"
      />
    </div>

    <CrowdfundingDeliveryTable
      v-if="deliveries.length > 0 && rewards.length > 0"
      :currentPage="currentPage"
      :deliveries="deliveries"
      :rewards="rewards"
      :itemsPerPage="ITEMS_PER_PAGE"
      @update-delivery="updateDelivery"
    />
  </div>
</template>
