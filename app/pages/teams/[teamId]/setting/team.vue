<script setup lang="ts">
  import { computed } from 'vue'
  import { useRoute } from 'vue-router'
  import TeamSetting from '../../../../../components/setting/team/TeamSetting.vue'

  const route = useRoute()
  const fallbackTeamId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'

  const teamId = computed(() => {
    const param = route.params.teamId
    return typeof param === 'string' && param.length > 0 ? param : fallbackTeamId
  })
</script>

<template>
  <TeamSetting :team-id="teamId" />
</template>
