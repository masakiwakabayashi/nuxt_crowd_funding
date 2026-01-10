import { createError, getQuery } from 'h3'
import type { Organization } from '@/shared/types/Organization'
import { fetchOrganizationWithProjects } from '@/server/repositories/organizationsRepository'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const organizationId = query.organizationId

  if (!organizationId || typeof organizationId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'organizationId is required',
    })
  }

  let data
  try {
    data = await fetchOrganizationWithProjects(organizationId)
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to fetch organization'
    throw createError({ statusCode: 500, statusMessage: message })
  }

  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Organization not found' })
  }

  const response: Organization = {
    id: data.id,
    name: data.name,
    created_at: data.created_at,
    updated_at: data.updated_at,
    projects: data.projects
  }

  return response
})
