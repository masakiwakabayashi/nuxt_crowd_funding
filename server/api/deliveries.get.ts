import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '../utils/supabaseClient'

// TODO: 型定義とかは別のファイルに移動させる

type DeliveryStatus = '未着手' | '作成中' | '完了'

type DeliveryRecord = {
  id: string
  status: DeliveryStatus
  created_at: string
  updated_at: string
  return: ReturnRecord | null
  supporter: SupporterRecord | null
}

type ReturnRecord = {
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
    return { deliveries: [] }
  }

  const { data: returnRows, error: returnError } = await supabase
    .from('returns')
    .select('id')
    .in('project_id', projectIds)

  if (returnError) {
    throw createError({ statusCode: 500, statusMessage: returnError.message })
  }

  const returnIds = (returnRows ?? []).map((returnRow) => returnRow.id)

  if (returnIds.length === 0) {
    return { deliveries: [] }
  }

  const { data, error } = await supabase
    .from('deliveries')
    .select(
      `
        id,
        status,
        created_at,
        updated_at,
        return:returns (
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
    )
    .in('return_id', returnIds)
    .order('created_at', { ascending: false })
    .returns<DeliveryRecord[]>()

  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }

  const deliveries = (data ?? []).map((delivery) => ({
    id: delivery.id,
    status: delivery.status,
    createdAt: delivery.created_at,
    updatedAt: delivery.updated_at,
    return: delivery.return
      ? {
          id: delivery.return.id,
          projectId: delivery.return.project_id,
          title: delivery.return.title,
          detail: delivery.return.detail,
          maxQuantity: delivery.return.max_quantity,
          categoryId: delivery.return.category_id,
          price: delivery.return.price,
          estimatedDelivery: delivery.return.estimated_delivery,
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

  return { deliveries }
})
