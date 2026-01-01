<script setup lang="ts">
  import { onMounted, ref } from 'vue'
  import { useRouter } from 'vue-router'
  import { getSupabaseBrowserClient } from '@/shared/utils/supabaseBrowserClient'

  // ログインページはヘッダーがないレイアウトを使う
  definePageMeta({ layout: 'blank' })

  const email = ref('')
  const password = ref('')
  const errorMessage = ref('')
  const isSubmitting = ref(false)

  const router = useRouter()
  const supabase = process.client ? getSupabaseBrowserClient() : null

  const redirectToDashboard = async () => {
    await router.replace('/')
  }

  const handleLogin = async () => {
    if (!supabase || isSubmitting.value) {
      return
    }

    errorMessage.value = ''
    isSubmitting.value = true

    try {
      const { error } = await supabase.auth.signInWithPassword({
        email: email.value,
        password: password.value,
      })

      if (error) {
        errorMessage.value =
          error.message || 'ログインに失敗しました。入力内容を確認してください。'
        return
      }

      await redirectToDashboard()
    } catch (err) {
      errorMessage.value = '予期せぬエラーが発生しました。時間をおいて再度お試しください。'
      console.error(err)
    } finally {
      isSubmitting.value = false
    }
  }

  onMounted(async () => {
    if (!supabase) return
    const { data } = await supabase.auth.getSession()
    if (data.session) {
      await redirectToDashboard()
    }
  })
</script>

<template>
  <main class="flex min-h-screen items-center justify-center text-slate-900">
    <div
      class="grid w-full max-w-5xl gap-6 rounded-3xl border border-white/80 bg-white/95 p-8 shadow-2xl shadow-emerald-100/60"
    >
      <section class="bg-white/95 p-6">
        <h2 class="text-lg font-semibold text-slate-900">サインイン</h2>
        <p class="text-sm text-slate-500">登録済みのメールとパスワードを入力してください。</p>

        <form @submit.prevent="handleLogin" class="mt-6 space-y-5">
          <label class="flex flex-col text-sm font-medium text-slate-700">
            メールアドレス
            <input
              v-model="email"
              type="email"
              placeholder="taro@example.com"
              class="mt-2 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-base text-slate-900 placeholder:text-slate-400 shadow-inner focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-100"
              required
            />
          </label>
          <label class="flex flex-col text-sm font-medium text-slate-700">
            パスワード
            <input
              v-model="password"
              type="password"
              placeholder="********"
              class="mt-2 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-base text-slate-900 placeholder:text-slate-400 shadow-inner focus:border-emerald-400 focus:outline-none focus:ring-2 focus:ring-emerald-100"
              required
            />
          </label>
          <p v-if="errorMessage" class="text-sm text-rose-500">{{ errorMessage }}</p>
          <button
            type="submit"
            class="inline-flex w-full items-center justify-center rounded-full bg-gradient-to-r from-emerald-500 to-teal-500 px-6 py-3 text-base font-semibold text-white shadow-lg shadow-emerald-200/60 transition hover:brightness-110 disabled:cursor-not-allowed disabled:opacity-60"
            :disabled="isSubmitting"
          >
            {{ isSubmitting ? '認証中...' : 'ログイン' }}
          </button>
        </form>
      </section>
    </div>
  </main>
</template>
