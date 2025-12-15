<template>
  <AppBackdrop>
    <div class="flex min-h-screen flex-col px-4 py-10 sm:px-8">
      <slot />
    </div>
  </AppBackdrop>
</template>

<script setup lang="ts">
  import AppBackdrop from '../../components/common/AppBackdrop.vue'
</script>
