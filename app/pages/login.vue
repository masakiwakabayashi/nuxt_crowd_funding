<template>
  <main class="min-h-screen bg-slate-950 text-white">
    <div class="mx-auto grid min-h-screen max-w-6xl grid-cols-1 lg:grid-cols-2">
      <section class="relative hidden flex-col justify-between overflow-hidden rounded-br-[80px] border border-white/10 bg-[radial-gradient(circle_at_top,_#22d3ee,_#0f172a_55%)] p-12 lg:flex">
        <div>
          <p class="text-sm font-semibold uppercase tracking-[0.3em] text-cyan-100">Crowd Funding Studio</p>
          <h1 class="mt-6 text-4xl font-bold leading-snug text-white">
            あなたのプロジェクトを
            <span class="text-cyan-200">一元管理</span>
          </h1>
          <p class="mt-4 max-w-md text-base leading-relaxed text-cyan-50/80">
            支援者情報からリターン履歴まで。Supabase で保護されたデータと Nuxt のスムーズな UI で、作業を止めずに次のアクションへつなげます。
          </p>
        </div>

        <ul class="mt-12 space-y-6">
          <li v-for="item in highlights" :key="item.title" class="flex items-start gap-4">
            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-white/10 text-2xl">
              {{ item.emoji }}
            </div>
            <div>
              <p class="text-lg font-semibold text-white">{{ item.title }}</p>
              <p class="text-sm text-cyan-50/80">{{ item.description }}</p>
            </div>
          </li>
        </ul>
      </section>

      <section class="flex items-center justify-center px-6 py-12 sm:px-10">
        <div class="w-full max-w-md space-y-8 rounded-3xl border border-white/10 bg-white/5 p-8 shadow-2xl shadow-cyan-500/10 backdrop-blur">
          <header>
            <p class="text-sm font-medium tracking-[0.3em] text-cyan-200">Sign in</p>
            <h2 class="mt-3 text-3xl font-semibold text-white">ログイン</h2>
            <p class="mt-2 text-sm text-white/70">
              Supabase 認証情報でダッシュボードへアクセスします。
            </p>
          </header>

          <div v-if="!hasSupabaseConfig" class="rounded-2xl border border-yellow-400/50 bg-yellow-500/10 p-4 text-sm text-yellow-100">
            <p class="font-semibold">環境変数が設定されていません</p>
            <p class="mt-1">
              <code>NUXT_PUBLIC_SUPABASE_URL</code> と <code>NUXT_PUBLIC_SUPABASE_ANON_KEY</code> を設定してください。
            </p>
          </div>

          <form class="space-y-6" @submit.prevent="handleLogin">
            <label class="block text-sm font-medium text-white/80">
              メールアドレス
              <input
                v-model.trim="form.email"
                type="email"
                autocomplete="email"
                required
                class="mt-2 w-full rounded-2xl border border-white/10 bg-slate-900/60 px-4 py-3 text-base text-white placeholder:text-white/30 focus:border-cyan-300 focus:outline-none focus:ring-2 focus:ring-cyan-400/50"
                placeholder="you@example.com"
              />
            </label>

            <label class="block text-sm font-medium text-white/80">
              パスワード
              <div class="relative mt-2">
                <input
                  v-model="form.password"
                  :type="showPassword ? 'text' : 'password'"
                  autocomplete="current-password"
                  required
                  minlength="6"
                  class="w-full rounded-2xl border border-white/10 bg-slate-900/60 px-4 py-3 pr-12 text-base text-white placeholder:text-white/30 focus:border-cyan-300 focus:outline-none focus:ring-2 focus:ring-cyan-400/50"
                  placeholder="パスワード"
                />
                <button
                  type="button"
                  class="absolute inset-y-0 right-3 flex items-center text-sm text-white/60 hover:text-white"
                  @click="showPassword = !showPassword"
                >
                  {{ showPassword ? '非表示' : '表示' }}
                </button>
              </div>
            </label>

            <div class="flex items-center justify-between text-sm text-white/70">
              <label class="flex items-center gap-2">
                <input v-model="form.remember" type="checkbox" class="h-4 w-4 rounded border-white/30 bg-slate-900 text-cyan-400 focus:ring-cyan-300" />
                次回から自動的にログイン
              </label>
              <NuxtLink class="font-semibold text-cyan-200 hover:text-cyan-100" to="/">パスワードを忘れた?</NuxtLink>
            </div>

            <button
              type="submit"
              class="flex w-full items-center justify-center gap-2 rounded-2xl bg-cyan-400/90 px-4 py-3 text-base font-semibold text-cyan-950 transition hover:bg-cyan-300 disabled:cursor-not-allowed disabled:opacity-40"
              :disabled="!canSubmit || isSubmitting"
            >
              <span v-if="isSubmitting" class="h-5 w-5 animate-spin rounded-full border-2 border-cyan-900 border-t-transparent"></span>
              {{ isSubmitting ? 'ログイン中...' : 'サインイン' }}
            </button>
          </form>

          <p v-if="feedback" :class="[
            'rounded-2xl border px-4 py-3 text-sm',
            feedback.type === 'success'
              ? 'border-emerald-300/50 bg-emerald-400/10 text-emerald-100'
              : 'border-rose-300/50 bg-rose-400/10 text-rose-100'
          ]">
            {{ feedback.message }}
          </p>

          <div class="space-y-3 rounded-3xl border border-white/10 bg-white/5 p-4 text-sm text-white/70">
            <p class="text-xs font-semibold uppercase tracking-[0.2em] text-white/60">クイックヒント</p>
            <p>テスト用のメールとパスワードを入力すれば即座にダッシュボードへリダイレクトされます。</p>
            <p class="text-xs text-white/50">サポートが必要ですか？ <a class="font-semibold text-cyan-200" href="mailto:support@example.com">support@example.com</a></p>
          </div>
        </div>
      </section>
    </div>
  </main>
</template>

<script setup lang="ts">
import { createClient } from '@supabase/supabase-js'
import { computed, reactive, ref } from 'vue'

useHead({ title: 'ログイン | Crowd Funding Ops' })

const runtimeConfig = useRuntimeConfig()

const supabaseUrl = runtimeConfig.public.supabaseUrl
const supabaseAnonKey = runtimeConfig.public.supabaseAnonKey
const supabaseClient = supabaseUrl && supabaseAnonKey ? createClient(supabaseUrl, supabaseAnonKey) : null

const form = reactive({
  email: '',
  password: '',
  remember: true,
})

const showPassword = ref(false)
const isSubmitting = ref(false)
const feedback = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const hasSupabaseConfig = computed(() => Boolean(supabaseClient))
const canSubmit = computed(() => form.email.trim() !== '' && form.password.trim().length >= 6 && hasSupabaseConfig.value)

const router = useRouter()

const handleLogin = async () => {
  if (!hasSupabaseConfig.value || !supabaseClient) {
    feedback.value = { type: 'error', message: 'Supabase の設定が不足しています。' }
    return
  }

  feedback.value = null
  isSubmitting.value = true

  try {
    const { error } = await supabaseClient.auth.signInWithPassword({
      email: form.email.trim(),
      password: form.password,
    })

    if (error) {
      feedback.value = { type: 'error', message: error.message }
      return
    }

    feedback.value = { type: 'success', message: 'ログインに成功しました。少しお待ちください…' }
    setTimeout(async () => {
      await router.push('/')
    }, 600)
  } catch (err) {
    const message = err instanceof Error ? err.message : '予期せぬエラーが発生しました。'
    feedback.value = { type: 'error', message }
    console.error(err)
  } finally {
    isSubmitting.value = false
  }
}

const highlights = [
  { title: '複数プロジェクトの状況把握', description: '達成率や次の発送タスクをひと目で確認できます。', emoji: '📊' },
  { title: '支援者データベース', description: 'Supabase の行レベルセキュリティで安全に管理します。', emoji: '🛡️' },
  { title: 'チーム連携', description: 'スタッフロールごとに権限を分離し、最小限の操作でシェア。', emoji: '🤝' },
]
</script>

<style scoped>
main::before {
  content: '';
  position: fixed;
  inset: 0;
  background: radial-gradient(circle at top, rgba(45, 212, 191, 0.15), transparent 50%);
  pointer-events: none;
}
</style>
