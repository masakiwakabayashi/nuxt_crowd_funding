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
      <section id="contact" class="mt-12 rounded-3xl bg-white p-10 shadow-xl">
        <form class="mt-8 space-y-5">
          <label class="flex flex-col text-sm font-medium text-slate-700">
            お名前
            <input
              type="text"
              placeholder="山田 太郎"
              class="mt-2 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-900 placeholder:text-slate-400 focus:border-cyan-400 focus:outline-none focus:ring-2 focus:ring-cyan-100"
            />
          </label>
          <label class="flex flex-col text-sm font-medium text-slate-700">
            メールアドレス
            <input
              type="email"
              placeholder="taro@example.com"
              class="mt-2 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-900 placeholder:text-slate-400 focus:border-cyan-400 focus:outline-none focus:ring-2 focus:ring-cyan-100"
            />
          </label>
          <label class="flex flex-col text-sm font-medium text-slate-700">
            ご相談内容
            <textarea
              rows="4"
              placeholder="やりたいことや課題を自由にご記入ください"
              class="mt-2 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-slate-900 placeholder:text-slate-400 focus:border-cyan-400 focus:outline-none focus:ring-2 focus:ring-cyan-100"
            ></textarea>
          </label>
          <button
            type="button"
            class="inline-flex w-full items-center justify-center rounded-full bg-slate-900 px-6 py-3 text-base font-semibold text-white shadow-lg shadow-slate-900/30 transition hover:-translate-y-0.5 sm:w-auto"
          >
            送信イメージ
          </button>
        </form>
      </section>

</template>
