<template>
  <main class="flex flex-1 flex-col gap-8 pb-12">
    <section v-if="organization" class="grid gap-6">
      <article
        class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
      >
        <h2 class="text-base font-semibold text-slate-900">基本情報</h2>
        <div class="mt-4 space-y-4 text-sm text-slate-600">
          <dl>
            <dt class="text-xs uppercase tracking-wide text-slate-400">組織名</dt>
            <dd class="mt-1 text-xl font-semibold text-slate-900">
              {{ organization.name }}
            </dd>
          </dl>
          <dl>
            <dt class="text-xs uppercase tracking-wide text-slate-400">組織 ID</dt>
            <dd class="mt-1 font-mono text-sm text-slate-600">
              {{ organization.id }}
            </dd>
          </dl>
        </div>
      </article>

      <article
        class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
      >
        <h2 class="text-base font-semibold text-slate-900">タイムスタンプ</h2>
        <div class="mt-4 space-y-4 text-sm text-slate-600">
          <dl>
            <dt class="text-xs uppercase tracking-wide text-slate-400">作成日時</dt>
            <dd class="mt-1 text-base font-semibold text-slate-900">
              {{ formatDateTime(organization.createdAt) || '---' }}
            </dd>
          </dl>
          <dl>
            <dt class="text-xs uppercase tracking-wide text-slate-400">最終更新</dt>
            <dd class="mt-1 text-base font-semibold text-slate-900">
              {{ formatDateTime(organization.updatedAt) || '---' }}
            </dd>
          </dl>
        </div>
      </article>
    </section>

    <section
      v-else
      class="rounded-3xl border border-white/80 bg-white/95 p-6 text-sm text-slate-500 shadow-xl shadow-emerald-100/70"
    >
      組織情報が見つかりませんでした。
    </section>
  </main>
</template>

<script setup lang="ts">
  import { computed } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import { formatDateTime } from './../../../../shared/utils/date'

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
