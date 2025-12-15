<template>
  <main class="flex flex-1 flex-col gap-8 pb-12">
    <section
      class="relative overflow-hidden rounded-[32px] bg-gradient-to-br from-emerald-500 via-teal-500 to-slate-900 p-8 text-white shadow-2xl shadow-emerald-500/40"
    >
      <div
        aria-hidden="true"
        class="pointer-events-none absolute inset-y-0 right-8 h-40 w-40 rounded-full bg-white/20 blur-3xl"
      />
      <div class="relative z-10 flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-sm font-semibold uppercase tracking-[0.5em] text-white/70">
            Organization Settings
          </p>
          <h1 class="mt-2 text-3xl font-semibold leading-tight">
            組織情報と管理設定
          </h1>
          <p class="mt-3 text-sm text-white/90">
            契約中の組織プロフィールや、同期しているクラウドファンディングワークスペースを、Materialデザインのフルスクリーンカードで整理しました。
          </p>
        </div>

        <button
          type="button"
          class="inline-flex items-center justify-center rounded-full bg-white/90 px-6 py-3 text-sm font-semibold text-emerald-700 shadow-lg shadow-emerald-900/30 transition hover:bg-white disabled:cursor-not-allowed disabled:opacity-60"
          :disabled="isOrganizationLoading"
          @click="refreshOrganization()"
        >
          {{ isOrganizationLoading ? '読み込み中…' : '最新の情報に更新' }}
        </button>
      </div>
    </section>

    <section v-if="organization" class="grid gap-6 lg:grid-cols-2">
      <article
        class="rounded-[28px] border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
      >
        <h2 class="text-base font-semibold text-slate-900">基本情報</h2>
        <dl class="mt-4 space-y-4 text-sm text-slate-600">
          <div>
            <dt class="text-xs uppercase tracking-wide text-slate-400">組織名</dt>
            <dd class="mt-1 text-xl font-semibold text-slate-900">
              {{ organization.name }}
            </dd>
          </div>
          <div>
            <dt class="text-xs uppercase tracking-wide text-slate-400">組織 ID</dt>
            <dd class="mt-1 font-mono text-sm text-slate-600">
              {{ organization.id }}
            </dd>
          </div>
        </dl>
      </article>

      <article
        class="rounded-[28px] border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
      >
        <h2 class="text-base font-semibold text-slate-900">タイムスタンプ</h2>
        <dl class="mt-4 space-y-4 text-sm text-slate-600">
          <div>
            <dt class="text-xs uppercase tracking-wide text-slate-400">作成日時</dt>
            <dd class="mt-1 text-base font-semibold text-slate-900">
              {{ formatDateTime(organization.createdAt) || '---' }}
            </dd>
          </div>
          <div>
            <dt class="text-xs uppercase tracking-wide text-slate-400">最終更新</dt>
            <dd class="mt-1 text-base font-semibold text-slate-900">
              {{ formatDateTime(organization.updatedAt) || '---' }}
            </dd>
          </div>
        </dl>
      </article>
    </section>

    <section
      v-else
      class="rounded-[28px] border border-white/80 bg-white/95 p-6 text-sm text-slate-500 shadow-xl shadow-emerald-100/70"
    >
      組織情報が見つかりませんでした。
    </section>
  </main>
</template>

<script setup lang="ts">
  import { computed } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import { formatDateTime } from '@/server/utils/date'

  type Organization = {
    id: string
    name: string
    createdAt: string
    updatedAt: string
  }

  const organizationId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'

  // コンポーネントからAPIを呼び出すのではなくリポジトリから呼び出した方がいいか？
  const {
    data: organizationData,
    pending: isOrganizationLoading,
    error: organizationError,
    refresh: refreshOrganization,
  } = await useAsyncData<{ organization: Organization | null }>(
    `organization-settings-${organizationId}`,
    () => $fetch(`/api/organizations/${organizationId}`),
  )

  const organization = computed<Organization | null>(
    () => organizationData.value?.organization ?? null,
  )

</script>
