import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '@/plugins/supabaseServerClient'
import type { Delivery } from '@/shared/types/Delivery'

interface DeliveryQuery {
  projectId?: string | string[]
  page?: string | string[]
  itemsPerPage?: string | string[]
}

const toPositiveInteger = (value: string | string[] | undefined, defaultValue: number, maxValue?: number) => {
  const normalized = Array.isArray(value) ? value[0] : value
  const parsed = Number.parseInt(normalized ?? '', 10)
  const fallback = defaultValue

  if (!Number.isFinite(parsed) || parsed <= 0) {
    return fallback
  }

  if (typeof maxValue === 'number') {
    return Math.min(parsed, maxValue)
  }

  return parsed
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event) as DeliveryQuery
  const projectId = Array.isArray(query.projectId) ? query.projectId[0] : query.projectId

  if (!projectId) {
    throw createError({ statusCode: 400, statusMessage: 'projectId is required' })
  }

  const page = toPositiveInteger(query.page, 1)
  const itemsPerPage = toPositiveInteger(query.itemsPerPage, 20, 100)
  const from = (page - 1) * itemsPerPage
  const to = from + itemsPerPage - 1

  const supabase = getSupabaseServerClient()

  const { data, error, count } = await supabase
    .from('deliveries')
    .select(
      `
        *,
        supporter:supporters(*)
      `,
      { count: 'exact' },
    )
    .eq('project_id', projectId)
    .order('created_at', { ascending: true })
    .range(from, to)

  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }

  return {
    deliveries: (data ?? []) as Delivery[],
    totalDeliveries: count ?? 0,
  }
})
