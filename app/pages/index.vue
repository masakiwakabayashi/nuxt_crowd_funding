<template>
  <div class="min-h-screen bg-slate-50 p-6">
    <!-- ヘッダー -->
    <header class="mb-6 flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-800">
          クラウドファンディング納品ダッシュボード
        </h1>
        <p class="text-sm text-slate-500 mt-1">
          売り上げとリターン納品の状況をまとめて確認できます。
        </p>
      </div>

      <div class="flex items-center gap-3">
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

    <!-- KPIカード -->
    <section class="grid gap-4 md:grid-cols-4 mb-6">
      <div class="rounded-2xl bg-white p-4 shadow-sm">
        <p class="text-xs text-slate-500">総売上</p>
        <p class="mt-2 text-2xl font-bold">
          ¥{{ totalSales.toLocaleString() }}
        </p>
        <p class="mt-1 text-xs text-emerald-600">
          +{{ salesGrowth }}% （前期間比）
        </p>
      </div>

      <div class="rounded-2xl bg-white p-4 shadow-sm">
        <p class="text-xs text-slate-500">総支援者数</p>
        <p class="mt-2 text-2xl font-bold">
          {{ totalBackers.toLocaleString() }} 人
        </p>
        <p class="mt-1 text-xs text-slate-500">
          平均支援額 ¥{{ averagePledge.toLocaleString() }}
        </p>
      </div>

      <div class="rounded-2xl bg-white p-4 shadow-sm">
        <p class="text-xs text-slate-500">未納品リターン</p>
        <p class="mt-2 text-2xl font-bold text-amber-600">
          {{ pendingDeliveries }} 件
        </p>
        <p class="mt-1 text-xs text-slate-500">
          期限超過 {{ overdueDeliveries }} 件
        </p>
      </div>

      <div class="rounded-2xl bg-white p-4 shadow-sm">
        <p class="text-xs text-slate-500">納品率</p>
        <p class="mt-2 text-2xl font-bold">
          {{ deliveryRate }}%
        </p>
        <div class="mt-2 h-2 w-full overflow-hidden rounded-full bg-slate-100">
          <div
            class="h-full rounded-full bg-emerald-500 transition-all"
            :style="{ width: deliveryRate + '%' }"
          />
        </div>
      </div>
    </section>

    <!-- 中段：プロジェクト一覧 & ステータスサマリー -->
    <section class="grid gap-4 lg:grid-cols-3 mb-6">
      <!-- プロジェクト一覧 -->
      <div class="rounded-2xl bg-white p-4 shadow-sm lg:col-span-2">
        <div class="mb-3 flex items-center justify-between">
          <h2 class="text-sm font-semibold text-slate-700">
            プロジェクト別サマリー
          </h2>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
              <tr class="border-b bg-slate-50 text-xs text-slate-500">
                <th class="px-3 py-2 font-medium">プロジェクト</th>
                <th class="px-3 py-2 font-medium">売上</th>
                <th class="px-3 py-2 font-medium">支援数</th>
                <th class="px-3 py-2 font-medium">納品率</th>
                <th class="px-3 py-2 font-medium">納品期限</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="project in projects"
                :key="project.id"
                class="border-b last:border-0 hover:bg-slate-50/80 cursor-pointer"
                @click="selectedProjectId = project.id"
              >
                <td class="px-3 py-3">
                  <div class="font-medium text-slate-800">
                    {{ project.name }}
                  </div>
                  <div class="text-xs text-slate-500">
                    {{ project.category }}
                  </div>
                </td>
                <td class="px-3 py-3">
                  ¥{{ project.sales.toLocaleString() }}
                </td>
                <td class="px-3 py-3">
                  {{ project.backers.toLocaleString() }}人
                </td>
                <td class="px-3 py-3">
                  <div class="flex items-center gap-2">
                    <span class="text-sm font-semibold">
                      {{ project.deliveryRate }}%
                    </span>
                    <div
                      class="h-1.5 w-24 overflow-hidden rounded-full bg-slate-100"
                    >
                      <div
                        class="h-full rounded-full bg-emerald-500"
                        :style="{ width: project.deliveryRate + '%' }"
                      />
                    </div>
                  </div>
                </td>
                <td class="px-3 py-3 text-xs text-slate-500">
                  メイン納品期限: {{ project.mainDeadline }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- ステータスサマリー -->
      <div class="rounded-2xl bg-white p-4 shadow-sm">
        <h2 class="mb-3 text-sm font-semibold text-slate-700">
          納品ステータス内訳
        </h2>

        <ul class="space-y-3 text-sm">
          <li
            v-for="summary in statusSummary"
            :key="summary.status"
            class="flex items-center justify-between"
          >
            <div class="flex items-center gap-2">
              <span
                class="inline-flex h-2.5 w-2.5 rounded-full"
                :class="statusColorClass(summary.status)"
              />
              <span>{{ statusLabel(summary.status) }}</span>
            </div>
            <div class="text-right">
              <div class="font-semibold">
                {{ summary.count }}件
              </div>
              <div class="text-xs text-slate-500">
                {{ summary.rate }}%
              </div>
            </div>
          </li>
        </ul>

        <div class="mt-4 rounded-xl bg-slate-50 p-3 text-xs text-slate-500">
          <p class="font-medium mb-1">対応の優先度目安</p>
          <ul class="list-disc pl-4 space-y-1">
            <li>「期限超過」の未着手・準備中を最優先で対応</li>
            <li>次に今週が期限のリターンを確認</li>
          </ul>
        </div>
      </div>
    </section>

    <!-- 下段：納品管理テーブル -->
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
// ダッシュボード用のダミーデータを定義
type Project = {
  id: string
  name: string
  category: string
  sales: number
  backers: number
  deliveryRate: number
  mainDeadline: string
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
    sales: 3200000,
    backers: 420,
    deliveryRate: 76,
    mainDeadline: '2026-01-31',
  },
  {
    id: 'p2',
    name: 'インディーゲーム開発支援',
    category: 'ゲーム',
    sales: 1800000,
    backers: 230,
    deliveryRate: 62,
    mainDeadline: '2026-02-15',
  },
  {
    id: 'p3',
    name: '地域ローカルフード応援企画',
    category: 'フード',
    sales: 960000,
    backers: 150,
    deliveryRate: 89,
    mainDeadline: '2025-12-20',
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

// フィルタ
const selectedProjectId = ref<string | ''>('')
const filterStatus = ref<DeliveryStatus | ''>('')

// 集計用の算出プロパティ
const totalSales = computed(() =>
  projects.reduce((sum, p) => sum + p.sales, 0),
)

const totalBackers = computed(() =>
  projects.reduce((sum, p) => sum + p.backers, 0),
)

// 仮の成長率・平均支援額（実際は期間比較して算出）
const salesGrowth = computed(() => 18)
const averagePledge = computed(() =>
  Math.round(totalSales.value / totalBackers.value),
)

const pendingDeliveries = computed(
  () => deliveries.filter((d) => d.status !== 'completed').length,
)

const overdueDeliveries = computed(
  () => deliveries.filter((d) => d.isOverdue).length,
)

const deliveryRate = computed(() => {
  const total = deliveries.length
  if (total === 0) return 0
  const completed = deliveries.filter((d) => d.status === 'completed').length
  return Math.round((completed / total) * 100)
})

// ステータスサマリー
const allStatuses: DeliveryStatus[] = [
  'pending',
  'preparing',
  'shipped',
  'completed',
]

const statusSummary = computed(() => {
  const total = deliveries.length || 1
  return allStatuses.map((status) => {
    const list = deliveries.filter((d) => d.status === status)
    const count = list.length
    const rate = Math.round((count / total) * 100)
    return { status, count, rate }
  })
})

// テーブルのフィルタリング
const filteredDeliveries = computed(() =>
  deliveries.filter((d) => {
    const matchProject =
      !selectedProjectId.value || d.projectId === selectedProjectId.value
    const matchStatus =
      !filterStatus.value || d.status === filterStatus.value
    return matchProject && matchStatus
  }),
)

// ユーティリティ系関数
const relatedProjectName = (projectId: string) => {
  const p = projects.find((p) => p.id === projectId)
  return p ? p.name : '不明なプロジェクト'
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

const statusColorClass = (status: DeliveryStatus) => {
  switch (status) {
    case 'pending':
      return 'bg-slate-400'
    case 'preparing':
      return 'bg-amber-400'
    case 'shipped':
      return 'bg-sky-400'
    case 'completed':
      return 'bg-emerald-500'
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

// ボタンのハンドラ（今は console.log だけ）
const openDetail = (delivery: Delivery) => {
  // ここでモーダル表示などに繋げる
  console.log('詳細を開く: ', delivery)
}

const markAsCompleted = (delivery: Delivery) => {
  // 実際はAPI経由でステータス更新などを行う
  console.log('納品完了にする: ', delivery)
  // ダミーなのでアラートだけ出す
  alert(`「${delivery.supporterName}」さんのリターンを完了にします（ダミー）`)
}
</script>
