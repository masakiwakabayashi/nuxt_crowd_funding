<script setup lang="ts">
  import CrowdfundingDashboard from '../../../../../components/crowdfunding/CrowdfundingDashboard.vue'

  const organizationId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'
</script>

<template>
  <main class="flex flex-1 flex-col gap-8 pb-12">
    <CrowdfundingDashboard :organization-id="organizationId" />

    <!-- 組織設定へのリンクがこのページにないと開発がしずらいので、一旦ここにリンクを置いておく -->
    <NuxtLink
      :to="`/organizations/${organizationId}/settings`"
      class="mt-6 inline-flex w-full items-center justify-center rounded-2xl bg-white/90 px-5 py-3 text-sm font-semibold text-emerald-600 shadow-lg shadow-emerald-900/20 transition hover:bg-white"
    >
      組織設定へ
    </NuxtLink>
  </main>
</template>
