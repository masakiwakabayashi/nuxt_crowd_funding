<script setup lang="ts">
  import { computed, reactive, ref, watch } from 'vue'
  import { useAsyncData } from 'nuxt/app'
  import { useRoute } from 'vue-router'
  import { formatDateTime, formatDisplayDate } from '~/shared/utils/date'
  import type {
    OrganizationProject,
    ProjectFormValues,
    ProjectStats as ProjectStatsType,
  } from '~/shared/types/Crowdfunding'

  const props = defineProps<{
    selectedProjectId: string
    projectStats: ProjectStatsType
  }>()

  const emit = defineEmits<{
    (e: 'update:selectedProjectId', value: string): void
  }>()

  const route = useRoute()

  const fallbackOrganizationId = 'b52b352c-6dee-4ddc-bf0a-cc95d85f1a11'
  const organizationId = computed(() => {
    const param = route.params.organizationId
    return typeof param === 'string' && param.length > 0
      ? param
      : fallbackOrganizationId
  })

  const {
    data: projectsData,
    pending: areProjectsLoading,
    error: projectsError,
  } = await useAsyncData<{ projects: OrganizationProject[] }>(
    `organization-projects-${organizationId.value}`,
    () => $fetch(`/api/organizations/${organizationId.value}/projects`),
  )

  const projects = computed<OrganizationProject[]>(
    () => projectsData.value?.projects ?? [],
  )

  const ensureSelection = () => {
    if (props.selectedProjectId && projects.value.some((p) => p.id === props.selectedProjectId)) {
      return
    }

    const firstProjectId = projects.value[0]?.id
    if (firstProjectId) {
      emit('update:selectedProjectId', firstProjectId)
    }
  }

  watch(projects, ensureSelection)
  watch(
    () => props.selectedProjectId,
    () => ensureSelection(),
  )
  ensureSelection()

  const selectedProjectIdModel = computed({
    get: () => props.selectedProjectId,
    set: (value: string) => emit('update:selectedProjectId', value),
  })

  const selectedProject = computed<OrganizationProject | null>(() =>
    projects.value.find((project) => project.id === selectedProjectIdModel.value) ?? null,
  )

  const projectForm = reactive<ProjectFormValues>({
    title: '',
    description: '',
    startAt: '',
    endAt: '',
    goal: 0,
  })

  const toLocalInputValue = (value: string) => {
    if (!value) return ''
    const date = new Date(value)
    if (Number.isNaN(date.getTime())) return ''
    const tzOffset = date.getTimezoneOffset()
    const adjusted = new Date(date.getTime() - tzOffset * 60 * 1000)
    return adjusted.toISOString().slice(0, 16)
  }

  const resetProjectForm = () => {
    if (!selectedProject.value) {
      projectForm.title = ''
      projectForm.description = ''
      projectForm.startAt = ''
      projectForm.endAt = ''
      projectForm.goal = 0
      return
    }

    projectForm.title = selectedProject.value.title
    projectForm.description = selectedProject.value.description ?? ''
    projectForm.startAt = toLocalInputValue(selectedProject.value.startAt)
    projectForm.endAt = toLocalInputValue(selectedProject.value.endAt)
    projectForm.goal = selectedProject.value.goal
  }

  watch(selectedProject, resetProjectForm, { immediate: true })

  const toIsoString = (value: string) => {
    if (!value) return ''
    const date = new Date(value)
    return Number.isNaN(date.getTime()) ? '' : date.toISOString()
  }

  const isSavingProject = ref(false)

  const handleProjectSave = async () => {
    if (!selectedProject.value) return
    isSavingProject.value = true

    try {
      await new Promise((resolve) => setTimeout(resolve, 600))
      console.log('update project payload', {
        id: selectedProject.value.id,
        title: projectForm.title,
        description: projectForm.description,
        startAt: toIsoString(projectForm.startAt),
        endAt: toIsoString(projectForm.endAt),
        goal: projectForm.goal,
      })
    } finally {
      isSavingProject.value = false
    }
  }

  const projectPeriodLabel = computed(() => {
    if (!projectForm.startAt || !projectForm.endAt) {
      return '未設定'
    }

    const start = formatDisplayDate(projectForm.startAt)
    const end = formatDisplayDate(projectForm.endAt)
    return `${start || '-'} 〜 ${end || '-'}`
  })

  const formatCurrency = (value: number) =>
    new Intl.NumberFormat('ja-JP', {
      style: 'currency',
      currency: 'JPY',
      maximumFractionDigits: 0,
    }).format(Number.isNaN(value) ? 0 : value)

  const projectStats = computed(() => props.projectStats)
</script>

<template>
  <section class="rounded-3xl border border-white/80 bg-white/95 p-6 shadow-xl shadow-emerald-100/70">
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
        <label class="text-xs font-medium text-slate-500">対象プロジェクト</label>
        <select
          v-model="selectedProjectIdModel"
          class="mt-1 w-full rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm text-slate-700"
          :disabled="areProjectsLoading || !projects.length"
        >
          <option value="" disabled>プロジェクトを選択</option>
          <option v-for="project in projects" :key="project.id" :value="project.id">
            {{ project.title }}
          </option>
        </select>
      </div>
    </div>

    <div v-if="selectedProject" class="mt-8 grid gap-8 lg:grid-cols-[minmax(0,1.4fr)_minmax(280px,1fr)]">
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
                {{ formatDateTime(selectedProject.createdAt) || '-' }}
              </dd>
            </div>
            <div>
              <dt>最終更新</dt>
              <dd class="mt-1 text-sm font-semibold text-slate-900">
                {{ formatDateTime(selectedProject.updatedAt) || '-' }}
              </dd>
            </div>
          </dl>
        </article>
      </aside>
    </div>

    <p v-else-if="!areProjectsLoading && !projectsError" class="mt-6 text-sm text-slate-500">
      クラウドファンディングがまだ登録されていません。組織詳細ページから先に作成してください。
    </p>

    <p v-else-if="projectsError" class="mt-6 text-sm text-rose-500">
      プロジェクト情報の取得に失敗しました。
    </p>

    <p v-else class="mt-6 text-sm text-slate-500">読み込み中...</p>
  </section>
</template>
