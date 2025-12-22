import type { Config } from 'tailwindcss'

export default {
  content: [
    './app/app.{js,ts,vue}',
    './app/components/**/*.{vue,js,ts}',
    './app/layouts/**/*.vue',
    './app/pages/**/*.vue',
    './app/plugins/**/*.{js,ts}',
    './components/**/*.{vue,js,ts}',
    './shared/**/*.{js,ts}',
    './server/**/*.{js,ts}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
} satisfies Config
