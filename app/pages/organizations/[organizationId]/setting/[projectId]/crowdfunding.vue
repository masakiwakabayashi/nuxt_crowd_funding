<script setup lang="ts">
  import { ref, watch } from 'vue'
  import { useRoute } from 'vue-router'
  import { useAsyncData } from 'nuxt/app'
  import ProjectSetting from '../../../../../../components/setting/crowdfunding/ProjectSetting.vue'
  import ReturnSetting from '../../../../../../components/setting/crowdfunding/ReturnSetting.vue'
  import type { ProjectStats } from '../../../../../../shared/types/Crowdfunding'
  import type { Project } from '@/shared/types/Project'

  const route = useRoute()

  const selectedProjectId = ref(
    typeof route.params.projectId === 'string' ? route.params.projectId : '',
  )
  const organizationId = ref(
    typeof route.params.organizationId === 'string' ? route.params.organizationId : '',
  )

  watch(
    () => route.params.projectId,
    (projectId) => {
      if (typeof projectId === 'string' && projectId !== selectedProjectId.value) {
        selectedProjectId.value = projectId
      }
    },
  )
  watch(
    () => route.params.organizationId,
    (id) => {
      if (typeof id === 'string' && id !== organizationId.value) {
        organizationId.value = id
      }
    },
  )

  const { data: project } = await useAsyncData<Project | null>(
    'project-details',
    async () => {
      if (!selectedProjectId.value) return null

      return $fetch('/api/project', {
        query: { projectId: selectedProjectId.value },
      })
    },
    { watch: [selectedProjectId, organizationId] },
  )

  const projectStats = ref<ProjectStats>({ totalSupporters: 0, totalSales: 0 })

  const handleProjectSelection = (value: string) => {
    selectedProjectId.value = value
  }

  const handleStatsUpdate = (stats: ProjectStats) => {
    projectStats.value = stats
  }
</script>

<template>
  <main class="flex flex-1 flex-col gap-8 pb-16">
    <ProjectSetting
      v-if="project"
      :organization-id="organizationId"
      :project-stats="projectStats"
      :project="project"
      @update:selected-project-id="handleProjectSelection"
    />

    <ReturnSetting
      v-if="project?.rewards"
      :organization-id="organizationId"
      :selected-project-id="selectedProjectId"
      :rewards="project.rewards"
      @update:stats="handleStatsUpdate"
    />
  </main>
</template>
