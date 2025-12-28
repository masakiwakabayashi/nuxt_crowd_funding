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
        class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70"
      >
        <div class="flex flex-wrap items-center justify-between gap-4">
          <div>
            <h2 class="text-base font-semibold text-slate-900">クラウドファンディング</h2>
            <p class="mt-1 text-sm text-slate-500">
              この組織に紐づいているプロジェクトの一覧です。
            </p>
          </div>
          <span
            v-if="areProjectsLoading"
            class="text-xs font-medium text-emerald-600"
          >
            読み込み中...
          </span>
        </div>

        <div v-if="projects.length" class="mt-6 grid gap-4">
          <article
            v-for="project in projects"
            :key="project.id"
            class="rounded-2xl border border-emerald-50 bg-emerald-50/60 p-5"
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
                  {{ formatDisplayDate(project.startAt) || '-' }} 〜
                  {{ formatDisplayDate(project.endAt) || '-' }}
                </dd>
              </div>
              <div>
                <dt class="text-xs uppercase tracking-wide text-slate-400">作成</dt>
                <dd class="mt-1">
                  {{ formatDateTime(project.createdAt) || '-' }}
                </dd>
              </div>
              <div>
                <dt class="text-xs uppercase tracking-wide text-slate-400">最終更新</dt>
                <dd class="mt-1">
                  {{ formatDateTime(project.updatedAt) || '-' }}
                </dd>
              </div>
            </dl>
          </article>
        </div>

        <p
          v-else-if="!areProjectsLoading && !projectsError"
          class="mt-6 text-sm text-slate-500"
        >
          紐づいているクラウドファンディングはまだありません。
        </p>

        <p v-else-if="projectsError" class="mt-6 text-sm text-rose-500">
          クラウドファンディング情報の取得に失敗しました。
        </p>
      </section>
    </template>

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
  import {
    formatDateTime,
    formatDisplayDate,
  } from './../../../../../shared/utils/date'

  type Organization = {
    id: string
    name: string
    createdAt: string
    updatedAt: string
  }

  type CrowdfundingProject = {
    id: string
    title: string
    description: string | null
    startAt: string
    endAt: string
    goal: number
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

  const {
    data: projectData,
    pending: areProjectsLoading,
    error: projectsError,
    refresh: refreshProjects,
  } = await useAsyncData<{ projects: CrowdfundingProject[] }>(
    `organization-projects-${organizationId}`,
    () => $fetch(`/api/organizations/${organizationId}/projects`),
  )

  const projects = computed<CrowdfundingProject[]>(
    () => projectData.value?.projects ?? [],
  )

  const formatCurrency = (value: number): string =>
    new Intl.NumberFormat('ja-JP', {
      style: 'currency',
      currency: 'JPY',
      maximumFractionDigits: 0,
    }).format(value)

</script>
