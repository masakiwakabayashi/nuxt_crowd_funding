
// これはあとで消す

export type ProjectSummary = {
  name: string
  period: string
  totalSales: number
  goal: number
  remainingSales: number
  remainingDays: number
  deadline: string
}

export type ProjectSummaryRecord = {
  id: string
  title: string
  startAt: string
  endAt: string
  goal: number
  totalSales: number
  supporterCount: number
} | null

export type DeliveryStatus = '未着手' | '作成中' | '完了'

export type DeliveryRecord = {
  id: string
  status: DeliveryStatus
  createdAt: string
  updatedAt: string
  return: {
    id: string
    projectId: string
    title: string
    detail: string | null
    maxQuantity: number | null
    categoryId: string | null
    price: string | number | null
    estimatedDelivery: string | null
  } | null
  supporter: {
    id: string
    projectId: string
    name: string
    address: string | null
    email: string | null
    pledgedAmount: string | number | null
  } | null
}

export type Delivery = {
  id: string
  projectId: string
  supporterName: string
  supporterEmail: string
  rewardName: string
  amount: number | null
  dueDate: string
  status: DeliveryStatus
  isOverdue: boolean
  isDueSoon: boolean
  overdueDays?: number
}

export type Reward = {
  id: string
  title: string
  description: string
  price: number
  supporters: number
  limit?: number
  deliverySchedule: string
  category: string
}

export type RewardRecord = {
  id: string
  projectId: string
  title: string
  description: string
  price: number
  supporters: number
  limit: number | null
  deliverySchedule: string | null
  category: string
}
