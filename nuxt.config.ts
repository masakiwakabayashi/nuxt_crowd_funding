// https://nuxt.com/docs/api/configuration/nuxt-config
import tailwindcss from "@tailwindcss/vite";

export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  css: ['./app/assets/css/main.css'],
  vite: {
    plugins: [
      tailwindcss(),
    ],
  },
  runtimeConfig: {
    // 🔐 サーバー専用（secret key）
    supabaseSecretKey: process.env.NUXT_SUPABASE_SECRET_KEY,
    public: {
      // 🌐 クライアントで使う（publishable key）
      supabaseUrl: process.env.NUXT_SUPABASE_URL,
      supabasePublishableKey: process.env.NUXT_SUPABASE_PUBLISHABLE_KEY,
    },
  },
})
