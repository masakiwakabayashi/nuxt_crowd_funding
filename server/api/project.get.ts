import { createError, getQuery } from 'h3'
import z from 'zod'
import { fetchProjectWithRelations } from '@/server/repositories/projectsRepository'
import { projectWithRelationsSchema } from '@/server/schemas/projects'

const singleQueryValue = (value: unknown): string | undefined => {
  if (Array.isArray(value)) {
    return typeof value[0] === 'string' ? value[0] : undefined
  }

  return typeof value === 'string' ? value : undefined
}

const projectQuerySchema = z.object({
  projectId: z.preprocess(
    (value) => singleQueryValue(value) ?? '',
    z.string().min(1, 'projectId is required'),
  ),
})

export default defineEventHandler(async (event) => {
  const parsedQuery = projectQuerySchema.safeParse(getQuery(event))

  if (!parsedQuery.success) {
    throw createError({
      statusCode: 400,
      statusMessage: parsedQuery.error.issues[0]?.message ?? 'Invalid query parameters',
    })
  }

  const { projectId } = parsedQuery.data

  let data
  try {
    data = await fetchProjectWithRelations(projectId)
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to fetch project'
    throw createError({ statusCode: 500, statusMessage: message })
  }

  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Project not found' })
  }

  return projectWithRelationsSchema.parse(data)
})
