import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '../../shared/utils/supabaseServerClient'

// TODO: 型定義とかは別のファイルに移動させる

type DeliveryStatus = '未着手' | '作成中' | '完了'

type DeliveryRecord = {
  id: string
  project_id: string
  reward_id: string
  supporter_id: string
  status: DeliveryStatus
  due_date: string | null
  completed_at: string | null
  created_at: string
  updated_at: string
  reward: RewardRecord | null
  supporter: SupporterRecord | null
}

type RewardRecord = {
  id: string
  project_id: string
  title: string
  detail: string | null
  max_quantity: number | null
  category_id: string | null
  price: string | number | null
  estimated_delivery: string | null
}

type SupporterRecord = {
  id: string
  project_id: string
  name: string
  address: string | null
  email: string
  pledged_amount: string | number | null
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const organizationId = query.organizationId

  if (!organizationId || typeof organizationId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'organizationId (UUID) is required',
    })
  }

  const pageParam = Number(query.page ?? '1')
  const limitParam = Number(query.limit ?? '20')
  const page = Number.isFinite(pageParam) && pageParam > 0 ? Math.floor(pageParam) : 1
  const limitRaw = Number.isFinite(limitParam) && limitParam > 0 ? Math.floor(limitParam) : 20
  const limit = Math.min(limitRaw, 100)
  const statusFilter = isDeliveryStatus(query.status) ? query.status : null
  const projectFilter =
    typeof query.projectId === 'string' && query.projectId.length > 0
      ? query.projectId
      : null

  const supabase = getSupabaseServerClient()

  const { data: projectRows, error: projectError } = await supabase
    .from('projects')
    .select('id')
    .eq('organization_id', organizationId)

  if (projectError) {
    throw createError({ statusCode: 500, statusMessage: projectError.message })
  }

  const projectIds = (projectRows ?? []).map((project) => project.id)

  if (projectIds.length === 0) {
    return { deliveries: [], total: 0, page, limit }
  }

  let targetProjectIds = projectIds
  if (projectFilter) {
    targetProjectIds = projectIds.filter((id) => id === projectFilter)
    if (targetProjectIds.length === 0) {
      return { deliveries: [], total: 0, page, limit }
    }
  }

  const rangeStart = (page - 1) * limit
  const rangeEnd = rangeStart + limit - 1

  let queryBuilder = supabase
    .from('deliveries')
    .select(
      `
        id,
        project_id,
        reward_id,
        supporter_id,
        status,
        due_date,
        completed_at,
        created_at,
        updated_at,
        reward:rewards (
          id,
          project_id,
          title,
          detail,
          max_quantity,
          category_id,
          price,
          estimated_delivery
        ),
        supporter:supporters (
          id,
          project_id,
          name,
          address,
          email,
          pledged_amount
        )
      `,
      { count: 'exact' },
    )
    .in('project_id', targetProjectIds)

  if (statusFilter) {
    queryBuilder = queryBuilder.eq('status', statusFilter)
  }

  const { data, error, count } = await queryBuilder
    .order('created_at', { ascending: false })
    .range(rangeStart, rangeEnd)
    .returns<DeliveryRecord[]>()

  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }

  const deliveries = (data ?? []).map((delivery) => ({
    id: delivery.id,
    projectId: delivery.project_id,
    rewardId: delivery.reward_id,
    supporterId: delivery.supporter_id,
    status: delivery.status,
    dueDate: delivery.due_date,
    completedAt: delivery.completed_at,
    createdAt: delivery.created_at,
    updatedAt: delivery.updated_at,
    reward: delivery.reward
      ? {
          id: delivery.reward.id,
          projectId: delivery.reward.project_id,
          title: delivery.reward.title,
          detail: delivery.reward.detail,
          maxQuantity: delivery.reward.max_quantity,
          categoryId: delivery.reward.category_id,
          price: delivery.reward.price,
          estimatedDelivery: delivery.reward.estimated_delivery,
        }
      : null,
    supporter: delivery.supporter
      ? {
          id: delivery.supporter.id,
          projectId: delivery.supporter.project_id,
          name: delivery.supporter.name,
          address: delivery.supporter.address,
          email: delivery.supporter.email,
          pledgedAmount: delivery.supporter.pledged_amount,
        }
      : null,
  }))

  return {
    deliveries,
    total: count ?? 0,
    page,
    limit,
  }
})

const deliveryStatuses: DeliveryStatus[] = ['未着手', '作成中', '完了']

const isDeliveryStatus = (value: unknown): value is DeliveryStatus =>
  typeof value === 'string' && deliveryStatuses.includes(value as DeliveryStatus)
