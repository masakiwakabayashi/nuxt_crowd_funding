<script setup lang="ts">
import { ref } from 'vue';

const email = ref('');
const password = ref('');

function handleLogin() {
  // ログイン処理をここに実装してください
  console.log('ログイン試行:', email.value, password.value);
}
</script>


<template>
  <main class="bg-slate-50">
    <div class="mx-auto max-w-5xl px-5 py-10 md:px-10 lg:py-16">
      <section class="mt-12 rounded-3xl bg-white p-10 shadow-xl max-w-md mx-auto">
        <form @submit.prevent="handleLogin" class="mt-8 space-y-5">
          <label class="flex flex-col text-sm font-medium text-slate-700">
            メールアドレス
            <input
              v-model="email"
              type="email"
              placeholder="taro@example.com"
              class="mt-2 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-900 placeholder:text-slate-400 focus:border-cyan-400 focus:outline-none focus:ring-2 focus:ring-cyan-100"
              required
            />
          </label>
          <label class="flex flex-col text-sm font-medium text-slate-700">
            パスワード
            <input
              v-model="password"
              type="password"
              placeholder="********"
              class="mt-2 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-900 placeholder:text-slate-400 focus:border-cyan-400 focus:outline-none focus:ring-2 focus:ring-cyan-100"
              required
            />
          </label>
          <button
            type="submit"
            class="inline-flex w-full items-center justify-center rounded-full bg-slate-900 px-6 py-3 text-base font-semibold text-white shadow-lg shadow-slate-900/30 transition hover:-translate-y-0.5 sm:w-auto"
          >
            ログイン
          </button>
        </form>
      </section>
    </div>
  </main>
</template>
