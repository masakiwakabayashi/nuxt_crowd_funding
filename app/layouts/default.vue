<template>
  <div class="min-h-screen bg-slate-50">
    <div class="mx-auto max-w-6xl space-y-6 px-4 py-6 sm:px-6 lg:px-8">
      <Header />
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
  import Header from '../../components/common/Header.vue'
</script>
