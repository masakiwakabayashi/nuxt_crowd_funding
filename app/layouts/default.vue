<template>
  <AppBackdrop>
    <div class="flex min-h-screen flex-col px-4 pb-10 pt-6 text-slate-900">
      <div class="flex w-full flex-1 flex-col gap-6">
        <Header />
        <slot />
      </div>
    </div>
  </AppBackdrop>
</template>

<script setup lang="ts">
  import Header from '../../components/common/Header.vue'
  import AppBackdrop from '../../components/common/AppBackdrop.vue'
</script>
