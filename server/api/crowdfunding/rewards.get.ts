import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '../../../shared/utils/supabaseClient'

type ReturnRow = {
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
  return_id: string
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

  const { data: returnRows, error: returnError } = await supabase
    .from('returns')
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
    .returns<ReturnRow[]>()

  if (returnError) {
    throw createError({ statusCode: 500, statusMessage: returnError.message })
  }

  const returnIds = (returnRows ?? []).map((reward) => reward.id)

  if (returnIds.length === 0) {
    return { rewards: [] }
  }

  const { data: deliveryRows, error: deliveryError } = await supabase
    .from('deliveries')
    .select('return_id, supporter_id')
    .in('return_id', returnIds)
    .returns<DeliveryRow[]>()

  if (deliveryError) {
    throw createError({ statusCode: 500, statusMessage: deliveryError.message })
  }

  const supportersMap = new Map<string, Set<string>>()

  for (const delivery of deliveryRows ?? []) {
    if (!supportersMap.has(delivery.return_id)) {
      supportersMap.set(delivery.return_id, new Set())
    }

    supportersMap.get(delivery.return_id)?.add(delivery.supporter_id)
  }

  const rewards = (returnRows ?? []).map((reward) => {
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
