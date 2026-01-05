<script setup lang="ts">
  import { computed, ref, watchEffect } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import { formatDateTime, formatDisplayDate } from '../../../shared/utils/date'
  import type { Organization } from "../../../shared/types/Organization"
  import type { Project } from '../../../shared/types/Project'

  const props = defineProps<{
    organizationId: string
  }>()

  const organization = ref<Organization>()
  const projects = ref<Project[]>([])

  const {
    data,
    pending: isLoading,
    error,
  } = await useAsyncData<Organization>(
    `organization-${props.organizationId}`,
    () =>
      $fetch('/api/organization', {
        query: { organizationId: props.organizationId },
      }),
  )

  watchEffect(() => {
    const fetchedOrganization = data.value
    if (!fetchedOrganization) return

    organization.value = fetchedOrganization
    projects.value = fetchedOrganization.projects ?? []
  })

  const formatCurrency = (value: number): string =>
    new Intl.NumberFormat('ja-JP', {
      style: 'currency',
      currency: 'JPY',
      maximumFractionDigits: 0,
    }).format(value)

  const projectSettingsLink = (projectId: string): string =>
    `/organizations/${props.organizationId}/setting/${encodeURIComponent(projectId)}/crowdfunding`
</script>

<template>
  <main class="flex flex-1 flex-col gap-8 pb-12">
    <template v-if="organization">
      <section class="grid gap-6">
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
                {{ formatDateTime(organization.created_at) }}
              </dd>
            </dl>
            <dl>
              <dt class="text-xs uppercase tracking-wide text-slate-400">最終更新</dt>
              <dd class="mt-1 text-base font-semibold text-slate-900">
                {{ formatDateTime(organization.updated_at) }}
              </dd>
            </dl>
          </div>
        </article>
      </section>

      <section
        class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
      >
        <div class="flex flex-wrap items-center justify-between gap-4">
          <div>
            <h2 class="text-base font-semibold text-slate-900">クラウドファンディング</h2>
            <p class="mt-1 text-sm text-slate-500">
              この組織に紐づいているプロジェクトの一覧です。
            </p>
          </div>
        </div>

        <div v-if="projects.length" class="mt-6 grid gap-4">
          <NuxtLink
            v-for="project in projects"
            :key="project.id"
            :to="projectSettingsLink(project.id)"
            class="block rounded-2xl border border-emerald-50 bg-emerald-50/60 p-5 transition hover:-translate-y-0.5 hover:border-emerald-200 hover:bg-emerald-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-300"
            :aria-label="`${project.title} の設定を開く`"
          >
            <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
              <div>
                <h3 class="text-lg font-semibold text-slate-900">
                  {{ project.title }}
                </h3>
                <p class="mt-1 text-sm text-slate-600">
                  {{ project.description || '説明が登録されていません。' }}
                </p>
              </div>
              <div class="text-right text-sm text-slate-500">
                <p class="text-xs uppercase tracking-wide text-slate-400">目標金額</p>
                <p class="text-base font-semibold text-emerald-700">
                  {{ formatCurrency(project.goal) }}
                </p>
              </div>
            </div>

            <dl class="mt-4 grid gap-4 text-sm text-slate-600 md:grid-cols-3">
              <div>
                <dt class="text-xs uppercase tracking-wide text-slate-400">募集期間</dt>
                <dd class="mt-1 font-medium text-slate-900">
                  {{ formatDisplayDate(project.start_at) || '-' }} 〜
                  {{ formatDisplayDate(project.end_at) || '-' }}
                </dd>
              </div>
              <div>
                <dt class="text-xs uppercase tracking-wide text-slate-400">作成</dt>
                <dd class="mt-1">
                  {{ formatDateTime(project.created_at) || '-' }}
                </dd>
              </div>
              <div>
                <dt class="text-xs uppercase tracking-wide text-slate-400">最終更新</dt>
                <dd class="mt-1">
                  {{ formatDateTime(project.updated_at) || '-' }}
                </dd>
              </div>
            </dl>
          </NuxtLink>
        </div>
      </section>
    </template>
  </main>
</template>
