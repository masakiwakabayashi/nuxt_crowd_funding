import { getSupabaseServerClient } from '@/app/plugins/supabase.server'
import type { Delivery } from '@/shared/types/Delivery'

export interface DeliveryPaginationRange {
  from: number
  to: number
}

export const fetchDeliveriesByProjectId = async (
  projectId: string,
  range: DeliveryPaginationRange,
) => {
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
    .range(range.from, range.to)

  if (error) {
    throw new Error(error.message)
  }

  return {
    deliveries: (data ?? []) as Delivery[],
    totalDeliveries: count ?? 0,
  }
}
