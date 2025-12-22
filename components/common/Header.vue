<template>
  <header
    class="relative overflow-hidden rounded-3xl border border-white/80 bg-white/90 p-6 shadow-xl shadow-emerald-100/70 backdrop-blur"
  >
    <div
      aria-hidden="true"
      class="pointer-events-none absolute -right-12 top-0 h-48 w-48 rounded-full bg-emerald-200/70 blur-3xl"
    >
    </div>
    <div
      aria-hidden="true"
      class="pointer-events-none absolute bottom-0 left-10 h-16 w-36 rounded-full bg-sky-200/70 blur-2xl"
    >
    </div>

    <div class="relative z-10 flex gap-6">
      <div class="flex items-center gap-4">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.35em] text-emerald-600">
            Material Workspace
          </p>
          <h1 class="text-2xl font-bold text-slate-900">
            Nuxt Crowd Funding
          </h1>
          <p class="text-sm text-slate-500">
            クラウドファンディング運用ダッシュボード
          </p>
        </div>
      </div>

      <div class="flex flex-col gap-4 text-sm text-slate-500">
        <div class="flex flex-1 flex-wrap justify-end gap-3">
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
