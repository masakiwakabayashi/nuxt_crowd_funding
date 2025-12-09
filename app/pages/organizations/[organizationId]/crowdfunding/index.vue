<script setup lang="ts">
  import CrowdfundingDashboard from '../../../../../components/crowdfunding/CrowdfundingDashboard.vue'
</script>

<template>
  <div class="min-h-screen bg-slate-50 p-6">
    <header class="mb-6 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wide text-emerald-600">
          Delivery Tracker
        </p>
        <h1 class="text-2xl font-bold text-slate-900">
          クラウドファンディング納品管理テーブル
        </h1>
        <p class="text-sm text-slate-500">
          支援者ごとのステータスと期限を一覧で確認できます。
        </p>
      </div>
    </header>

    <CrowdfundingDashboard />
  </div>
</template>
