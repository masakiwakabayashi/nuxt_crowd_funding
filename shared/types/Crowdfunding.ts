export type TeamProject = {
  id: string
  title: string
  description: string | null
  startAt: string
  endAt: string
  goal: number
  createdAt: string
  updatedAt: string
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

export type EditableReward = RewardRecord & {
  draft: {
    title: string
    description: string
    price: number
    limit: number | null
    deliverySchedule: string | null
    category: string
  }
  isEditing: boolean
  isNew: boolean
}

export type ProjectFormValues = {
  title: string
  description: string
  startAt: string
  endAt: string
  goal: number
}

export type ProjectStats = {
  totalSupporters: number
  totalSales: number
}
