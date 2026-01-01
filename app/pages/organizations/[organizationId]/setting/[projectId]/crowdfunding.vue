
<!-- コンポーネントをわける -->


<template>
  <main class="flex flex-1 flex-col gap-8 pb-16">
    <ProjectSetting
      :selected-project-id="selectedProjectId"
      :project-stats="projectStats"
      @update:selected-project-id="handleProjectSelection"
    />

    <ReturnSetting
      :selected-project-id="selectedProjectId"
      @update:stats="handleStatsUpdate"
    />
  </main>
</template>

<script setup lang="ts">
  import { ref, watch } from 'vue'
  import { useRoute } from 'vue-router'
  import ProjectSetting from '../../../../../../components/setting/crowdfunding/ProjectSetting.vue'
  import ReturnSetting from '../../../../../../components/setting/crowdfunding/ReturnSetting.vue'
  import type { ProjectStats } from '../../../../../../shared/types/Crowdfunding'

  const route = useRoute()

  const selectedProjectId = ref(
    typeof route.params.projectId === 'string' ? route.params.projectId : '',
  )

  watch(
    () => route.params.projectId,
    (projectId) => {
      if (typeof projectId === 'string' && projectId !== selectedProjectId.value) {
        selectedProjectId.value = projectId
      }
    },
  )

  const projectStats = ref<ProjectStats>({ totalSupporters: 0, totalSales: 0 })

  const handleProjectSelection = (value: string) => {
    selectedProjectId.value = value
  }

  const handleStatsUpdate = (stats: ProjectStats) => {
    projectStats.value = stats
  }
</script>
