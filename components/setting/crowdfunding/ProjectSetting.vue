<script setup lang="ts">
  import { computed, reactive, ref, watch } from 'vue'
  import { formatDateTime, formatDisplayDate } from '../../../shared/utils/date'
  import type {
    ProjectFormValues,
    ProjectStats as ProjectStatsType,
  } from '../../../shared/types/Crowdfunding'
  import type { Project } from '../../../shared/types/Project'

  const props = defineProps<{
    organizationId: string
    projectStats: ProjectStatsType
    project: Project
  }>()

  const createEmptyFormValues = (): ProjectFormValues => ({
    title: '',
    description: '',
    startAt: '',
    endAt: '',
    goal: 0,
  })

  const projectForm = reactive<ProjectFormValues>(createEmptyFormValues())
  const lastSavedForm = ref<ProjectFormValues | null>(null)

  const assignFormValues = (values: ProjectFormValues) => {
    projectForm.title = values.title
    projectForm.description = values.description
    projectForm.startAt = values.startAt
    projectForm.endAt = values.endAt
    projectForm.goal = values.goal
  }

  const formatCurrency = (value: number) =>
    new Intl.NumberFormat('ja-JP', {
      style: 'currency',
      currency: 'JPY',
      maximumFractionDigits: 0,
    }).format(Number.isNaN(value) ? 0 : value)

  const projectPeriodLabel = computed(() => {
    const start = projectForm.startAt ? formatDisplayDate(projectForm.startAt) : ''
    const end = projectForm.endAt ? formatDisplayDate(projectForm.endAt) : ''

    if (!start && !end) return '未設定'
    if (start && end) return `${start} 〜 ${end}`
    return `${start || '未設定'} 〜 ${end || '未設定'}`
  })

  const isSavingProject = ref(false)

  const resetProjectForm = () => {
    if (lastSavedForm.value) {
      assignFormValues(lastSavedForm.value)
      return
    }

    assignFormValues(createEmptyFormValues())
  }

  const handleProjectSave = async () => {
    // あとで実装する
  }
</script>

<template>
  <section v-if="project" class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70">
    <div class="flex flex-wrap items-start justify-between gap-4">
      <div>
        <p class="text-xs uppercase tracking-wide text-slate-400">
          クラウドファンディング概要
        </p>
        <h1 class="mt-1 text-2xl font-semibold text-slate-900">
          プロジェクトの基本情報
        </h1>
        <p class="mt-2 text-sm text-slate-500">
          プロジェクト名や募集期間、目標金額を編集できます。
        </p>
      </div>
      <div class="min-w-[240px]">
        <div class="text-xs font-medium text-slate-500">
          対象プロジェクト: {{ project.title }}
        </div>
      </div>
    </div>

    <div class="mt-8 grid gap-8 lg:grid-cols-[minmax(0,1.4fr)_minmax(280px,1fr)]">
      <form class="space-y-6" @submit.prevent="handleProjectSave">
        <div>
          <label class="text-xs font-medium text-slate-500">プロジェクト名</label>
          <input
            v-model="projectForm.title"
            type="text"
            class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-3 text-base text-slate-900 focus:border-emerald-400 focus:outline-none"
            placeholder="例：地域菜園の拡張プロジェクト"
          />
        </div>

        <div>
          <label class="text-xs font-medium text-slate-500">概要</label>
          <textarea
            v-model="projectForm.description"
            rows="4"
            class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-3 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
            placeholder="プロジェクトの内容や目的を記載してください"
          />
        </div>

        <div class="grid gap-4 md:grid-cols-2">
          <div>
            <label class="text-xs font-medium text-slate-500">募集開始</label>
            <input
              v-model="projectForm.startAt"
              type="datetime-local"
              class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
            />
          </div>
          <div>
            <label class="text-xs font-medium text-slate-500">募集終了</label>
            <input
              v-model="projectForm.endAt"
              type="datetime-local"
              class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
            />
          </div>
        </div>

        <div>
          <label class="text-xs font-medium text-slate-500">目標金額 (円)</label>
          <input
            v-model.number="projectForm.goal"
            type="number"
            min="0"
            step="1000"
            class="mt-1 w-full rounded-2xl border border-slate-200 px-4 py-2 text-sm text-slate-900 focus:border-emerald-400 focus:outline-none"
          />
        </div>

        <div class="flex flex-wrap justify-end gap-3">
          <button
            type="button"
            class="rounded-2xl border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600"
            @click="resetProjectForm"
            :disabled="isSavingProject"
          >
            変更をリセット
          </button>
          <button
            type="submit"
            class="rounded-2xl bg-emerald-500 px-6 py-2 text-sm font-semibold text-white shadow-lg shadow-emerald-300/50 disabled:opacity-50"
            :disabled="isSavingProject"
          >
            {{ isSavingProject ? '保存中...' : '概要を更新' }}
          </button>
        </div>
      </form>

      <aside class="space-y-6">
        <article class="rounded-2xl border border-emerald-50 bg-emerald-50/60 p-5 text-sm text-slate-700">
          <p class="text-xs uppercase tracking-wide text-emerald-600">
            プロジェクト概要
          </p>
          <dl class="mt-4 space-y-3">
            <div>
              <dt class="text-xs text-slate-500">募集期間</dt>
              <dd class="mt-1 font-semibold text-slate-900">
                {{ projectPeriodLabel }}
              </dd>
            </div>
            <div>
              <dt class="text-xs text-slate-500">現在の目標金額</dt>
              <dd class="mt-1 text-lg font-semibold text-emerald-700">
                {{ formatCurrency(projectForm.goal) }}
              </dd>
            </div>
            <div class="grid grid-cols-2 gap-3 text-center">
              <div>
                <p class="text-xs text-slate-500">支援者数</p>
                <p class="mt-1 text-lg font-semibold text-slate-900">
                  {{ projectStats.totalSupporters }}
                </p>
              </div>
              <div>
                <p class="text-xs text-slate-500">売上見込み</p>
                <p class="mt-1 text-lg font-semibold text-emerald-700">
                  {{ formatCurrency(projectStats.totalSales) }}
                </p>
              </div>
            </div>
          </dl>
        </article>

        <article class="rounded-2xl border border-white/50 bg-white/60 p-5 text-xs text-slate-500">
          <dl class="space-y-3">
            <div>
              <dt>作成日時</dt>
              <dd class="mt-1 text-sm font-semibold text-slate-900">
                {{ formatDateTime(project.created_at) || '-' }}
              </dd>
            </div>
            <div>
              <dt>最終更新</dt>
              <dd class="mt-1 text-sm font-semibold text-slate-900">
                {{ formatDateTime(project.updated_at) || '-' }}
              </dd>
            </div>
          </dl>
        </article>
      </aside>
    </div>
  </section>
</template>
