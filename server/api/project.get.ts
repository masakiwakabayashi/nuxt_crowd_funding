import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '@/shared/utils/supabaseServerClient'
import type { Project } from '@/shared/types/Projects'
import type { Reward } from '@/shared/types/Rewards'
import type { Delivery } from '@/shared/types/Deliveries'

type DeliveryRow = Delivery

type RewardRow = Omit<Reward, 'price'> & {
  price: string | number | null
  deliveries: DeliveryRow[] | null
}

type ProjectRow = Omit<Project, 'goal'> & {
  goal: string | number | null
  rewards: RewardRow[] | null
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const projectId = query.projectId

  if (!projectId || typeof projectId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'projectId is required',
    })
  }

  const supabase = getSupabaseServerClient()

  const { data, error } = await supabase
    .from('projects')
    .select(
      `
        *,
        rewards:rewards (
          *,
          deliveries:deliveries(*)
        )
      `,
    )
    .eq('id', projectId)
    .single<ProjectRow>()

  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Project not found' })
  }

  const parsedGoal = Number(data.goal ?? 0)
  const goal = Number.isNaN(parsedGoal) ? 0 : parsedGoal

  const rewards: Array<Reward & { deliveries: Delivery[] }> = (data.rewards ?? []).map((rewardRow) => {
    const parsedPrice = Number(rewardRow.price ?? 0)
    const price = Number.isNaN(parsedPrice) ? 0 : parsedPrice

    const deliveries = (rewardRow.deliveries ?? []).map((deliveryRow) => ({
      id: deliveryRow.id,
      reward_id: deliveryRow.reward_id,
      supporter_id: deliveryRow.supporter_id,
      status: deliveryRow.status,
      created_at: deliveryRow.created_at,
      updated_at: deliveryRow.updated_at,
    }))

    return {
      id: rewardRow.id,
      project_id: rewardRow.project_id,
      title: rewardRow.title,
      detail: rewardRow.detail,
      max_quantity: rewardRow.max_quantity,
      category_id: rewardRow.category_id,
      price,
      estimated_delivery: rewardRow.estimated_delivery,
      created_at: rewardRow.created_at,
      updated_at: rewardRow.updated_at,
      deliveries,
    }
  })

  const project: Project & {
    rewards: Array<Reward & { deliveries: Delivery[] }>
    deliveries: Delivery[]
  } = {
    id: data.id,
    organization_id: data.organization_id,
    title: data.title,
    description: data.description,
    start_at: data.start_at,
    end_at: data.end_at,
    goal,
    created_at: data.created_at,
    updated_at: data.updated_at,
    rewards,
    deliveries: rewards.flatMap((reward) => reward.deliveries ?? []),
  }

  return project
})
