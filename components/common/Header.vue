<template>
  <header
    class="relative w-full overflow-hidden rounded-3xl border border-white/80 bg-white/90 p-6 shadow-xl shadow-emerald-100/70 backdrop-blur"
  >
    <div class="relative z-10 flex w-full items-center gap-6">
      <div class="flex flex-1 items-center gap-4">
        <div>
          <p class="text-xs font-semibold uppercase text-emerald-600">
            Material Workspace
          </p>
          <h1 class="text-4xl font-bold text-slate-900">
            Nuxt Crowd Funding
          </h1>
          <p class="text-sm text-slate-500">
            クラウドファンディング運用ダッシュボード
          </p>
        </div>
      </div>

      <div class="ml-auto flex flex-col gap-4 text-sm text-slate-500">
        <div class="flex flex-wrap justify-end gap-3">
          <NuxtLink
            to="/login"
            class="inline-flex items-center justify-center rounded-full bg-gradient-to-r from-emerald-500 to-teal-500 px-5 py-2 text-sm font-semibold text-white shadow-lg shadow-emerald-200/70 transition hover:brightness-110"
          >
            ログイン
          </NuxtLink>
        </div>
      </div>
    </div>
  </header>
</template>
