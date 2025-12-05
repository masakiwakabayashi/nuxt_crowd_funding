<template>
  <div class="min-h-screen bg-slate-50 p-6">
    <header class="mb-6 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wide text-emerald-600">
          Delivery Tracker
        </p>
        <h1 class="text-2xl font-bold text-slate-900">
          納品管理テーブル
        </h1>
        <p class="text-sm text-slate-500">
          支援者ごとのステータスと期限を一覧で確認できます。
        </p>
      </div>

      <div class="flex flex-wrap items-center gap-3">
        <select
          v-model="selectedProjectId"
          class="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm shadow-sm"
        >
          <option value="">全プロジェクト</option>
          <option
            v-for="project in projects"
            :key="project.id"
            :value="project.id"
          >
            {{ project.name }}
          </option>
        </select>

        <select
          v-model="filterStatus"
          class="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm shadow-sm"
        >
          <option value="">すべてのステータス</option>
          <option value="pending">未着手</option>
          <option value="preparing">準備中</option>
          <option value="shipped">発送済み</option>
          <option value="completed">完了</option>
        </select>
      </div>
    </header>

    <section class="rounded-2xl bg-white p-4 shadow-sm">
      <div class="mb-3 flex items-center justify-between">
        <h2 class="text-sm font-semibold text-slate-700">
          支援ごとの納品管理
        </h2>

        <div class="flex items-center gap-2 text-xs text-slate-500">
          <span class="inline-flex h-2 w-2 rounded-full bg-rose-500" /> 期限超過
          <span class="inline-flex h-2 w-2 rounded-full bg-amber-400" /> 期限間近
        </div>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full text-left text-sm">
          <thead>
            <tr class="border-b bg-slate-50 text-xs text-slate-500">
              <th class="px-3 py-2 font-medium">支援者</th>
              <th class="px-3 py-2 font-medium">リターン内容</th>
              <th class="px-3 py-2 font-medium">支援金額</th>
              <th class="px-3 py-2 font-medium">納品予定日</th>
              <th class="px-3 py-2 font-medium">ステータス</th>
              <th class="px-3 py-2 font-medium text-right">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="delivery in filteredDeliveries"
              :key="delivery.id"
              class="border-b last:border-0 hover:bg-slate-50/80"
            >
              <td class="px-3 py-3">
                <div class="font-medium text-slate-800">
                  {{ delivery.supporterName }}
                </div>
                <div class="text-xs text-slate-500">
                  {{ delivery.supporterEmail }}
                </div>
              </td>
              <td class="px-3 py-3">
                <div class="text-slate-800">
                  {{ delivery.rewardName }}
                </div>
                <div class="text-xs text-slate-500">
                  {{ relatedProjectName(delivery.projectId) }}
                </div>
              </td>
              <td class="px-3 py-3">
                ¥{{ delivery.amount.toLocaleString() }}
              </td>
              <td class="px-3 py-3">
                <div class="flex items-center gap-2">
                  <span
                    v-if="delivery.isOverdue"
                    class="inline-flex h-2 w-2 rounded-full bg-rose-500"
                  />
                  <span
                    v-else-if="delivery.isDueSoon"
                    class="inline-flex h-2 w-2 rounded-full bg-amber-400"
                  />
                  <span class="text-sm">
                    {{ delivery.dueDate }}
                  </span>
                </div>
                <div
                  v-if="delivery.isOverdue"
                  class="text-xs text-rose-600"
                >
                  期限超過（{{ delivery.overdueDays }}日）
                </div>
              </td>
              <td class="px-3 py-3">
                <span
                  class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-semibold"
                  :class="statusBadgeClass(delivery.status)"
                >
                  {{ statusLabel(delivery.status) }}
                </span>
              </td>
              <td class="px-3 py-3 text-right">
                <div class="flex justify-end gap-2">
                  <button
                    class="rounded-full border border-slate-200 px-2.5 py-1 text-xs text-slate-700 hover:bg-slate-50"
                    @click="openDetail(delivery)"
                  >
                    詳細
                  </button>
                  <button
                    class="rounded-full bg-emerald-500 px-2.5 py-1 text-xs font-semibold text-white hover:bg-emerald-600"
                    @click="markAsCompleted(delivery)"
                  >
                    納品完了にする
                  </button>
                </div>
              </td>
            </tr>

            <tr v-if="filteredDeliveries.length === 0">
              <td
                colspan="6"
                class="px-3 py-6 text-center text-sm text-slate-500"
              >
                条件に一致する支援がありません。
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
type Project = {
  id: string
  name: string
  category: string
}

type DeliveryStatus = 'pending' | 'preparing' | 'shipped' | 'completed'

type Delivery = {
  id: string
  projectId: string
  supporterName: string
  supporterEmail: string
  rewardName: string
  amount: number
  dueDate: string
  status: DeliveryStatus
  isOverdue: boolean
  isDueSoon: boolean
  overdueDays?: number
}

const projects: Project[] = [
  {
    id: 'p1',
    name: '新感覚ボードゲーム制作プロジェクト',
    category: 'プロダクト',
  },
  {
    id: 'p2',
    name: 'インディーゲーム開発支援',
    category: 'ゲーム',
  },
  {
    id: 'p3',
    name: '地域ローカルフード応援企画',
    category: 'フード',
  },
]

const deliveries: Delivery[] = [
  {
    id: 'd1',
    projectId: 'p1',
    supporterName: '山田 太郎',
    supporterEmail: 'taro@example.com',
    rewardName: 'ボードゲーム本体＋限定カード',
    amount: 12000,
    dueDate: '2025-11-30',
    status: 'preparing',
    isOverdue: true,
    isDueSoon: false,
    overdueDays: 5,
  },
  {
    id: 'd2',
    projectId: 'p1',
    supporterName: '佐藤 花子',
    supporterEmail: 'hanako@example.com',
    rewardName: 'デジタル版 + サントラDL',
    amount: 6000,
    dueDate: '2025-12-10',
    status: 'pending',
    isOverdue: false,
    isDueSoon: true,
  },
  {
    id: 'd3',
    projectId: 'p2',
    supporterName: 'John Doe',
    supporterEmail: 'john@example.com',
    rewardName: 'ゲーム本編 + アートブック',
    amount: 18000,
    dueDate: '2026-01-05',
    status: 'shipped',
    isOverdue: false,
    isDueSoon: false,
  },
  {
    id: 'd4',
    projectId: 'p3',
    supporterName: '鈴木 次郎',
    supporterEmail: 'jiro@example.com',
    rewardName: '詰め合わせセット（冷蔵）',
    amount: 8000,
    dueDate: '2025-12-18',
    status: 'completed',
    isOverdue: false,
    isDueSoon: false,
  },
  {
    id: 'd5',
    projectId: 'p3',
    supporterName: '高橋 美咲',
    supporterEmail: 'misaki@example.com',
    rewardName: 'お礼の手紙 + レシピPDF',
    amount: 4000,
    dueDate: '2025-12-08',
    status: 'pending',
    isOverdue: false,
    isDueSoon: true,
  },
]

const selectedProjectId = ref<string | ''>('')
const filterStatus = ref<DeliveryStatus | ''>('')

const filteredDeliveries = computed(() =>
  deliveries.filter((d) => {
    const matchProject =
      !selectedProjectId.value || d.projectId === selectedProjectId.value
    const matchStatus = !filterStatus.value || d.status === filterStatus.value
    return matchProject && matchStatus
  }),
)

const relatedProjectName = (projectId: string) => {
  const p = projects.find((p) => p.id === projectId)
  return p ? `${p.name}（${p.category}）` : '不明なプロジェクト'
}

const statusLabel = (status: DeliveryStatus | '') => {
  switch (status) {
    case 'pending':
      return '未着手'
    case 'preparing':
      return '準備中'
    case 'shipped':
      return '発送済み'
    case 'completed':
      return '完了'
    default:
      return '不明'
  }
}

const statusBadgeClass = (status: DeliveryStatus) => {
  switch (status) {
    case 'pending':
      return 'bg-slate-100 text-slate-700'
    case 'preparing':
      return 'bg-amber-50 text-amber-700 border border-amber-100'
    case 'shipped':
      return 'bg-sky-50 text-sky-700 border border-sky-100'
    case 'completed':
      return 'bg-emerald-50 text-emerald-700 border border-emerald-100'
  }
}

const openDetail = (delivery: Delivery) => {
  console.log('詳細を開く: ', delivery)
}

const markAsCompleted = (delivery: Delivery) => {
  console.log('納品完了にする: ', delivery)
  alert(`「${delivery.supporterName}」さんのリターンを完了にします（ダミー）`)
}
</script>
