import { createError } from 'h3'
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
}

type SupporterRecord = {
  id: string
  project_id: string
  name: string
  address: string | null
  email: string
}

export default defineEventHandler(async () => {
  const supabase = getSupabaseServerClient()

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
          category_id
        ),
        supporter:supporters (
          id,
          project_id,
          name,
          address,
          email
        )
      `,
    )
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
        }
      : null,
    supporter: delivery.supporter
      ? {
          id: delivery.supporter.id,
          projectId: delivery.supporter.project_id,
          name: delivery.supporter.name,
          address: delivery.supporter.address,
          email: delivery.supporter.email,
        }
      : null,
  }))

  return { deliveries }
})
