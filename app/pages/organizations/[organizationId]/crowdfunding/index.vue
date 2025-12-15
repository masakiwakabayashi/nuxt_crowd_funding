<script setup lang="ts">
  import CrowdfundingDashboard from '../../../../../components/crowdfunding/CrowdfundingDashboard.vue'

  const organizationId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'
</script>

<template>
  <main class="flex flex-1 flex-col gap-8 pb-12">
    <section
      class="relative overflow-hidden rounded-[32px] bg-gradient-to-br from-emerald-500 via-teal-500 to-sky-500 p-8 text-white shadow-2xl shadow-emerald-500/30"
    >
      <div
        aria-hidden="true"
        class="pointer-events-none absolute -right-12 top-10 h-64 w-64 rounded-full bg-white/20 blur-3xl"
      />
      <div
        aria-hidden="true"
        class="pointer-events-none absolute bottom-[-40%] left-20 h-72 w-72 rounded-full bg-emerald-300/40 blur-3xl"
      />

      <div class="relative z-10 grid gap-8 lg:grid-cols-[3fr,2fr]">
        <div>
          <p class="text-sm font-semibold uppercase tracking-[0.5em] text-white/70">
            Delivery Tracker
          </p>
          <h1 class="mt-3 text-3xl font-semibold leading-tight">
            クラウドファンディング納品管理ハブ
          </h1>
          <p class="mt-4 text-base text-white/90">
            支援者の納品状況をリアルタイムに整理し、ボトルネックを先回りで発見できる
            Materialデザインのコマンドセンターです。
          </p>

          <div class="mt-6 flex flex-wrap gap-3 text-sm font-semibold">
            <span class="rounded-full bg-white/20 px-4 py-2">
              納品状況監視
            </span>
            <span class="rounded-full bg-white/20 px-4 py-2">
              リターン管理
            </span>
            <span class="rounded-full bg-white/20 px-4 py-2">
              支援者ハイライト
            </span>
          </div>
        </div>

        <div class="rounded-[28px] bg-white/10 p-6 backdrop-blur">
          <p class="text-xs font-semibold uppercase tracking-[0.5em] text-white/70">
            Quick Navigation
          </p>
          <p class="mt-2 text-lg font-semibold">組織横断の設定にアクセス</p>
          <p class="text-sm text-white/80">
            リマインド設定やアカウント連携を編集するには設定画面へ。
          </p>

          <NuxtLink
            :to="`/organizations/${organizationId}/settings`"
            class="mt-6 inline-flex w-full items-center justify-center rounded-2xl bg-white/90 px-5 py-3 text-sm font-semibold text-emerald-600 shadow-lg shadow-emerald-900/20 transition hover:bg-white"
          >
            組織設定へ
          </NuxtLink>

          <dl class="mt-6 grid grid-cols-2 gap-4 text-left text-white/90">
            <div>
              <dt class="text-xs uppercase tracking-wide text-white/70">モード</dt>
              <dd class="text-xl font-semibold">ダッシュボード</dd>
            </div>
            <div>
              <dt class="text-xs uppercase tracking-wide text-white/70">ビュー</dt>
              <dd class="text-xl font-semibold">Crowdfunding</dd>
            </div>
          </dl>
        </div>
      </div>
    </section>

    <CrowdfundingDashboard :organization-id="organizationId" />
  </main>
</template>
