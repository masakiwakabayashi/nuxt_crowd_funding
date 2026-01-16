import { createError, getQuery } from 'h3'
import z from 'zod'
import { fetchOrganizationWithProjects } from '@/server/repositories/organizationsRepository'
import { organizationSchema } from '@/server/schemas/organizations'

const singleQueryValue = (value: unknown): string | undefined => {
  if (Array.isArray(value)) {
    return typeof value[0] === 'string' ? value[0] : undefined
  }

  return typeof value === 'string' ? value : undefined
}

const organizationQuerySchema = z.object({
  organizationId: z.preprocess(
    (value) => singleQueryValue(value) ?? '',
    z.string().min(1, 'organizationId is required'),
  ),
})

export default defineEventHandler(async (event) => {
  const parsedQuery = organizationQuerySchema.safeParse(getQuery(event))

  if (!parsedQuery.success) {
    throw createError({
      statusCode: 400,
      statusMessage: parsedQuery.error.issues[0]?.message ?? 'Invalid query parameters',
    })
  }

  const { organizationId } = parsedQuery.data

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

  return organizationSchema.parse(data)
})
