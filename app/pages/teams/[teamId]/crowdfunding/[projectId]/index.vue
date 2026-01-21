<script setup lang="ts">
  import CrowdfundingDashboard from '../../../../../../components/crowdfunding/CrowdfundingDashboard.vue'

  // あとでルーティングから取得するように修正する
  const teamId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'
  const projectId = '312f579c-e5a7-4c4f-9e6c-a0b2fdfa2099'
</script>

<template>
  <main class="flex flex-1 flex-col gap-8 pb-12">
    <CrowdfundingDashboard 
      :team-id="teamId"
      :project-id="projectId"
    />

    <!-- チーム設定へのリンクがこのページにないと開発がしずらいので、一旦ここにリンクを置いておく -->
    <NuxtLink
      :to="`/teams/${teamId}/setting/team`"
      class="mt-6 inline-flex w-full items-center justify-center rounded-2xl bg-white/90 px-5 py-3 text-sm font-semibold text-emerald-600 shadow-lg shadow-emerald-900/20 transition hover:bg-white"
    >
      チーム設定へ
    </NuxtLink>
  </main>
</template>
