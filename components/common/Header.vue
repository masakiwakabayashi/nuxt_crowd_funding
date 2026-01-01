<script setup lang="ts">
  import { computed, onMounted } from 'vue'
  import { storeToRefs } from 'pinia'
  import { useRouter } from 'vue-router'
  import { useAuthStore } from '@/stores/auth'

  const router = useRouter()
  const authStore = useAuthStore()
  const { user } = storeToRefs(authStore)

  const isAuthenticated = computed(() => Boolean(user.value))

  const handleLogout = async () => {
    await authStore.logout()
    await router.replace('/login')
  }

  onMounted(() => {
    authStore.fetchSession()
    authStore.startAuthListener()
  })
</script>

<template>
  <header
    class="relative w-full overflow-hidden rounded-3xl border border-white/80 bg-white/90 py-3 px-6 shadow-xl shadow-emerald-100/70 backdrop-blur"
  >
    <div class="relative z-10 flex w-full items-center gap-6">
      <div class="flex flex-1 items-center gap-4">
        <div>
          <p class="text-xs font-semibold uppercase text-emerald-600">
            Material Workspace
          </p>
          <h1 class="text-4xl font-bold text-slate-900">
            <NuxtLink to="/">Nuxt Crowd Funding</NuxtLink>
          </h1>
          <p class="text-sm text-slate-500">
            クラウドファンディング運用ダッシュボード
          </p>
        </div>
      </div>

      <div class="ml-auto flex flex-col gap-4 text-sm text-slate-500">
        <div class="flex flex-wrap justify-end gap-3">
          <button
            v-if="isAuthenticated"
            type="button"
            class="inline-flex items-center justify-center rounded-full border border-emerald-200 px-5 py-2 text-sm font-semibold text-emerald-700 shadow-sm transition hover:bg-emerald-50"
            @click="handleLogout"
          >
            ログアウト
          </button>
          <!-- 今は開発のために表示しておく -->
          <NuxtLink
            v-else
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
