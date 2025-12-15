<template>
  <!-- Keep a single root node so layout switches don't leave stale DOM -->
  <div class="min-h-screen">
    <slot />
  </div>
</template>
