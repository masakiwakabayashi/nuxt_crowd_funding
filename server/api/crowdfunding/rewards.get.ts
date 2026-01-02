import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '../../../shared/utils/supabaseServerClient'

type RewardRow = {
  id: string
  project_id: string
  title: string
  detail: string | null
  price: string | number | null
  max_quantity: number | null
  estimated_delivery: string | null
  category: { id: string; name: string } | null
}

type DeliveryRow = {
  reward_id: string
  supporter_id: string
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
    return { rewards: [] }
  }

  const { data: rewardRows, error: rewardError } = await supabase
    .from('rewards')
    .select(
      `
        id,
        project_id,
        title,
        detail,
        price,
        max_quantity,
        estimated_delivery,
        category:categories (
          id,
          name
        )
      `,
    )
    .in('project_id', projectIds)
    .returns<RewardRow[]>()

  if (rewardError) {
    throw createError({ statusCode: 500, statusMessage: rewardError.message })
  }

  const rewardIds = (rewardRows ?? []).map((reward) => reward.id)

  if (rewardIds.length === 0) {
    return { rewards: [] }
  }

  const { data: deliveryRows, error: deliveryError } = await supabase
    .from('deliveries')
    .select('reward_id, supporter_id')
    .in('reward_id', rewardIds)
    .returns<DeliveryRow[]>()

  if (deliveryError) {
    throw createError({ statusCode: 500, statusMessage: deliveryError.message })
  }

  const supportersMap = new Map<string, Set<string>>()

  for (const delivery of deliveryRows ?? []) {
    if (!supportersMap.has(delivery.reward_id)) {
      supportersMap.set(delivery.reward_id, new Set())
    }

    supportersMap.get(delivery.reward_id)?.add(delivery.supporter_id)
  }

  const rewards = (rewardRows ?? []).map((reward) => {
    const price = Number(reward.price ?? 0)
    const supporters = supportersMap.get(reward.id)?.size ?? 0

    return {
      id: reward.id,
      projectId: reward.project_id,
      title: reward.title,
      description: reward.detail ?? '',
      price: Number.isNaN(price) ? 0 : price,
      supporters,
      limit: reward.max_quantity,
      deliverySchedule: reward.estimated_delivery,
      category: reward.category?.name ?? '未分類',
    }
  })

  return { rewards }
})
