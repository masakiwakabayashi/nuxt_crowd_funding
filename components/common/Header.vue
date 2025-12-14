<script setup lang="ts">

</script>

<template>
  <header
    class="mb-6 flex flex-col gap-4 rounded-2xl bg-white/80 p-4 shadow-sm ring-1 ring-slate-100 backdrop-blur md:flex-row md:items-center md:justify-between"
  >
    <div class="flex items-center gap-4">
      <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-500 text-lg font-semibold text-white">
        CF
      </div>

      <div>
        <p class="text-xs font-semibold uppercase tracking-wide text-emerald-600">
          Nuxt Crowd Funding
        </p>
        <h1 class="text-xl font-bold text-slate-900">
          クラウドファンディング運用ダッシュボード
        </h1>
        <p class="text-sm text-slate-500">
          支援・納品の状況をまとめて把握
        </p>
      </div>
    </div>

    <div class="flex items-center gap-3">
      <slot name="actions" />
      <NuxtLink
        to="/login"
        class="inline-flex items-center justify-center rounded-lg bg-emerald-500 px-4 py-2 text-sm font-medium text-white shadow-sm transition hover:bg-emerald-600"
      >
        ログイン
      </NuxtLink>
    </div>
  </header>
</template>
