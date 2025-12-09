<script setup lang="ts">
  type ProjectSummary = {
    name: string
    period: string
    totalSales: number
    goal: number
    remainingSales: number
    remainingDays: number
    deadline: string
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

  type Reward = {
    id: string
    title: string
    description: string
    price: number
    supporters: number
    limit?: number
    deliverySchedule: string
    category: string
  }

  const props = defineProps<{
    organizationId: string
  }>()

  const filterStatus = ref<DeliveryStatus | ''>('')

  const projectSummary: ProjectSummary = {
    name: '新感覚ボードゲーム制作プロジェクト',
    period: '2025/10/01 〜 2025/12/31',
    totalSales: 3200000,
    goal: 5000000,
    remainingSales: 1800000,
    remainingDays: 45,
    deadline: '2025-12-31',
  }

  const goalProgress = computed(() =>
    Math.min(
      100,
      Math.round((projectSummary.totalSales / projectSummary.goal) * 100),
    ),
  )

  const rewards: Reward[] = [
    {
      id: 'r1',
      title: '限定サンクスカード & デジタル壁紙',
      description: 'プロジェクト限定アートをセットでお届けします。',
      price: 3000,
      supporters: 180,
      limit: 400,
      deliverySchedule: '2026年1月予定',
      category: 'デジタル',
    },
    {
      id: 'r2',
      title: 'ゲーム本体＋限定カードセット',
      description: '限定カード20枚が付いた物理版セット。',
      price: 12000,
      supporters: 260,
      limit: 350,
      deliverySchedule: '2026年2月発送',
      category: 'プロダクト',
    },
    {
      id: 'r3',
      title: 'デラックス版（アートブック付）',
      description: 'アートブックとサイン入り証明書を同梱した豪華版。',
      price: 22000,
      supporters: 95,
      limit: 150,
      deliverySchedule: '2026年3月発送',
      category: 'コレクターズ',
    },
    {
      id: 'r4',
      title: 'オンラインワークショップ参加権',
      description: '開発チームと一緒に体験できる限定ワークショップ。',
      price: 8000,
      supporters: 60,
      deliverySchedule: '2026年1月中旬',
      category: 'イベント',
    },
  ]

  const totalRewardSales = computed(() =>
    rewards.reduce((sum, reward) => sum + reward.price * reward.supporters, 0),
  )

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

  const filteredDeliveries = computed(() =>
    deliveries.filter((d) => {
      const matchProject =
        !selectedProjectId.value || d.projectId === selectedProjectId.value
      const matchStatus = !filterStatus.value || d.status === filterStatus.value
      return matchProject && matchStatus
    }),
  )

  const rewardSales = (reward: Reward) => reward.price * reward.supporters

  const rewardRemaining = (reward: Reward) =>
    reward.limit ? Math.max(reward.limit - reward.supporters, 0) : 0

  const rewardCapacityRate = (reward: Reward) => {
    if (!reward.limit) return 100
    if (reward.limit === 0) return 0
    return Math.min(100, Math.round((reward.supporters / reward.limit) * 100))
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

<template>
  <section
    class="mb-6 rounded-2xl bg-white p-5 shadow-sm"
    :data-organization-id="props.organizationId"
  >
    <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">
          プロジェクト名
        </p>
        <p class="mt-1 text-2xl font-bold text-slate-900">
          {{ projectSummary.name }}
        </p>
      </div>
      <div class="text-sm text-slate-500">
        <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">
          開催期間
        </p>
        <p class="mt-1 text-base font-semibold text-slate-800">
          {{ projectSummary.period }}
        </p>
      </div>
    </div>

    <div class="mt-4 grid gap-4 md:grid-cols-3">
      <div class="rounded-2xl bg-slate-50 p-4">
        <p class="text-xs text-slate-500">全体の売り上げ</p>
        <p class="mt-2 text-2xl font-bold text-slate-900">
          ¥{{ projectSummary.totalSales.toLocaleString() }}
        </p>
        <p class="text-xs text-emerald-600">
          達成率 {{ goalProgress }}%
        </p>
      </div>
      <div class="rounded-2xl bg-slate-50 p-4">
        <p class="text-xs text-slate-500">目標金額</p>
        <p class="mt-2 text-xl font-bold text-slate-900">
          ¥{{ projectSummary.goal.toLocaleString() }}
        </p>
        <div class="mt-3 text-sm text-slate-600">
          目標まで残り
          <span class="font-semibold text-slate-900">
            ¥{{ projectSummary.remainingSales.toLocaleString() }}
          </span>
        </div>
        <div class="mt-3 h-2 w-full overflow-hidden rounded-full bg-white">
          <div
            class="h-full rounded-full bg-emerald-500"
            :style="{ width: goalProgress + '%' }"
          />
        </div>
      </div>
      <div class="rounded-2xl bg-slate-50 p-4">
        <p class="text-xs text-slate-500">残り日数</p>
        <p class="mt-2 text-3xl font-bold text-slate-900">
          {{ projectSummary.remainingDays }}日
        </p>
        <p class="mt-1 text-xs text-slate-500">
          終了予定日 {{ projectSummary.deadline }}
        </p>
      </div>
    </div>
  </section>

  <section class="mb-6 rounded-2xl bg-white p-5 shadow-sm">
    <div
      class="mb-4 flex flex-col gap-2 md:flex-row md:items-center md:justify-between"
    >
      <div>
        <h2 class="text-sm font-semibold text-slate-700">リターン一覧</h2>
        <p class="text-xs text-slate-500">
          主要なリターン別の売り上げと支援状況を確認できます。
        </p>
      </div>
      <div class="text-right">
        <p class="text-xs text-slate-500">リターン売上合計</p>
        <p class="text-xl font-bold text-slate-900">
          ¥{{ totalRewardSales.toLocaleString() }}
        </p>
      </div>
    </div>

    <div class="grid gap-4 md:grid-cols-2">
      <article
        v-for="reward in rewards"
        :key="reward.id"
        class="rounded-2xl border border-slate-100 p-4 transition hover:border-emerald-200"
      >
        <div class="flex items-start justify-between gap-4">
          <div>
            <p class="text-xs uppercase tracking-wide text-slate-500">
              リターン
            </p>
            <h3 class="text-lg font-semibold text-slate-900">
              {{ reward.title }}
            </h3>
            <p class="mt-1 text-sm text-slate-600">
              {{ reward.description }}
            </p>
          </div>
          <div class="text-right">
            <p class="text-xs text-slate-500">価格</p>
            <p class="text-base font-semibold text-slate-900">
              ¥{{ reward.price.toLocaleString() }}
            </p>
          </div>
        </div>

        <dl class="mt-3 grid grid-cols-2 gap-2 text-sm text-slate-600 md:grid-cols-3">
          <div>
            <dt class="text-xs text-slate-500">支援者</dt>
            <dd class="text-base font-semibold text-slate-900">
              {{ reward.supporters }}人
            </dd>
          </div>
          <div>
            <dt class="text-xs text-slate-500">売り上げ</dt>
            <dd class="text-base font-semibold text-emerald-600">
              ¥{{ rewardSales(reward).toLocaleString() }}
            </dd>
          </div>
          <div class="md:text-right">
            <dt class="text-xs text-slate-500">納品目安</dt>
            <dd class="text-base font-semibold text-slate-900">
              {{ reward.deliverySchedule }}
            </dd>
          </div>
        </dl>

        <div class="mt-4 flex flex-wrap items-center gap-4 text-xs text-slate-500">
          <span>カテゴリ: {{ reward.category }}</span>
          <span v-if="reward.limit">
            残り {{ rewardRemaining(reward) }}枠 / 定員 {{ reward.limit }}
          </span>
          <span v-else>数量無制限</span>
        </div>

        <div class="mt-3 h-2 w-full overflow-hidden rounded-full bg-slate-100">
          <div
            class="h-full rounded-full bg-emerald-500"
            :style="{ width: rewardCapacityRate(reward) + '%' }"
          />
        </div>
      </article>
    </div>
  </section>

  <section class="rounded-2xl bg-white p-4 shadow-sm">
    <div class="mb-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
      <div>
        <h2 class="text-sm font-semibold text-slate-700">支援ごとの納品管理</h2>
        <div class="mt-2 flex items-center gap-2 text-xs text-slate-500">
          <span class="inline-flex h-2 w-2 rounded-full bg-rose-500" /> 期限超過
          <span class="inline-flex h-2 w-2 rounded-full bg-amber-400" /> 期限間近
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-3">
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
              <div v-if="delivery.isOverdue" class="text-xs text-rose-600">
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
            <td colspan="6" class="px-3 py-6 text-center text-sm text-slate-500">
              条件に一致する支援がありません。
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
