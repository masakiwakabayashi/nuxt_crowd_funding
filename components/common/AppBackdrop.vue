<template>
  <div
    class="relative min-h-screen overflow-hidden bg-gradient-to-br from-emerald-50 via-slate-50 to-sky-50"
  >
    <div aria-hidden="true" class="pointer-events-none absolute inset-0">
      <div
        class="absolute left-[-10%] top-[-15%] h-80 w-80 rounded-full bg-emerald-200/70 blur-3xl"
      >
      </div>
      <div
        class="absolute right-[-5%] top-1/4 h-96 w-96 rounded-full bg-sky-200/60 blur-3xl"
      >
      </div>
      <div
        class="absolute bottom-[-15%] left-1/3 h-96 w-[32rem] rounded-full bg-white/60 blur-3xl"
      >
      </div>
    </div>
    <div class="relative z-10">
      <slot />
    </div>
  </div>
</template>
