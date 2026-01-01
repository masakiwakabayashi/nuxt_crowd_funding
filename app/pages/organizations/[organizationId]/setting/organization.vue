<script setup lang="ts">
  import { computed } from 'vue'
  import { useRoute } from 'vue-router'
  import OrganizationSetting from '../../../../../components/setting/organization/OrganizationSetting.vue'

  const route = useRoute()
  const fallbackOrganizationId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'

  const organizationId = computed(() => {
    const param = route.params.organizationId
    return typeof param === 'string' && param.length > 0
      ? param
      : fallbackOrganizationId
  })
</script>

<template>
  <OrganizationSetting :organization-id="organizationId" />
</template>
