import { createError } from 'h3'
import { getSupabaseServerClient } from '../../utils/supabaseClient'

type OrganizationRow = {
  id: string
  name: string
  created_at: string
  updated_at: string
}

export default defineEventHandler(async (event) => {
  const organizationId = event.context.params?.organizationId

  if (!organizationId || typeof organizationId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'organizationId (UUID) is required',
    })
  }

  const supabase = getSupabaseServerClient()

  const { data, error, status } = await supabase
    .from('organizations')
    .select('id, name, created_at, updated_at')
    .eq('id', organizationId)
    .single<OrganizationRow>()

  if (error) {
    if (status === 406 || status === 404) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Organization not found',
      })
    }

    throw createError({ statusCode: 500, statusMessage: error.message })
  }

  if (!data) {
    throw createError({
      statusCode: 404,
      statusMessage: 'Organization not found',
    })
  }

  return {
    organization: {
      id: data.id,
      name: data.name,
      createdAt: data.created_at,
      updatedAt: data.updated_at,
    },
  }
})
