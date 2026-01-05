import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '@/shared/utils/supabaseServerClient'
import type { Organization } from '@/shared/types/Organization'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const organizationId = query.organizationId

  if (!organizationId || typeof organizationId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'organizationId is required',
    })
  }

  // この部分はリポジトリに分ける
  // ---------
  const supabase = getSupabaseServerClient()
  const { data, error } = await supabase
    .from('organizations')
    .select('*')
    .eq('id', organizationId)
    .maybeSingle()
  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Organization not found' })
  }
  // ---------

  const response: Organization = {
    id: data.id,
    name: data.name,
    created_at: data.created_at,
    updated_at: data.updated_at,
  }

  return response
})
