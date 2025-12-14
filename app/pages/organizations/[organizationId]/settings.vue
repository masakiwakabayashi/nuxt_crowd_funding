<template>
  <div class="min-h-screen bg-slate-50 p-6">
    <div class="mx-auto max-w-3xl space-y-6">
      <header class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wide text-emerald-600">
            Organization Settings
          </p>
          <h1 class="text-2xl font-bold text-slate-900">
            組織情報
          </h1>
        </div>

        <button
          type="button"
          class="inline-flex items-center justify-center rounded-lg border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm transition hover:border-emerald-500 hover:text-emerald-600 disabled:cursor-not-allowed disabled:opacity-60"
          :disabled="isOrganizationLoading"
          @click="refreshOrganization()"
        >
          {{ isOrganizationLoading ? '読み込み中…' : '最新の情報に更新' }}
        </button>
      </header>

      <section class="rounded-2xl bg-white p-6 shadow-sm">
        <div v-if="organization" class="space-y-6">
          <div>
            <h2 class="text-base font-semibold text-slate-800">基本情報</h2>
            <dl class="mt-4 divide-y divide-slate-100 text-sm">
              <div class="flex flex-col gap-1 py-3 sm:flex-row sm:items-center sm:justify-between">
                <dt class="text-slate-500">組織名</dt>
                <dd class="font-medium text-slate-900">{{ organization.name }}</dd>
              </div>
              <div class="flex flex-col gap-1 py-3 sm:flex-row sm:items-center sm:justify-between">
                <dt class="text-slate-500">組織 ID</dt>
                <dd class="font-mono text-xs text-slate-600">
                  {{ organization.id }}
                </dd>
              </div>
            </dl>
          </div>

          <div>
            <h2 class="text-base font-semibold text-slate-800">タイムスタンプ</h2>
            <dl class="mt-4 divide-y divide-slate-100 text-sm">
              <div class="flex flex-col gap-1 py-3 sm:flex-row sm:items-center sm:justify-between">
                <dt class="text-slate-500">作成日時</dt>
                <dd class="font-medium text-slate-900">
                  {{ formatDateTime(organization.createdAt) || '---' }}
                </dd>
              </div>
              <div class="flex flex-col gap-1 py-3 sm:flex-row sm:items-center sm:justify-between">
                <dt class="text-slate-500">最終更新</dt>
                <dd class="font-medium text-slate-900">
                  {{ formatDateTime(organization.updatedAt) || '---' }}
                </dd>
              </div>
            </dl>
          </div>
        </div>

        <div v-else class="text-sm text-slate-500">
          組織情報が見つかりませんでした。
        </div>
      </section>
    </div>
  </div>
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
