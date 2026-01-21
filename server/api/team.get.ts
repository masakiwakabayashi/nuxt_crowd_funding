import { createError, getQuery } from 'h3'
import z from 'zod'
import { fetchTeamWithProjects } from '@/server/repositories/teamsRepository'
import { teamSchema } from '@/server/schemas/teams'

const singleQueryValue = (value: unknown): string | undefined => {
  if (Array.isArray(value)) {
    return typeof value[0] === 'string' ? value[0] : undefined
  }

  return typeof value === 'string' ? value : undefined
}

const teamQuerySchema = z.object({
  teamId: z.preprocess(
    (value) => singleQueryValue(value) ?? '',
    z.string().min(1, 'teamId is required'),
  ),
})

export default defineEventHandler(async (event) => {
  const parsedQuery = teamQuerySchema.safeParse(getQuery(event))

  if (!parsedQuery.success) {
    throw createError({
      statusCode: 400,
      statusMessage: parsedQuery.error.issues[0]?.message ?? 'Invalid query parameters',
    })
  }

  const { teamId } = parsedQuery.data

  let data
  try {
    data = await fetchTeamWithProjects(teamId)
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to fetch team'
    throw createError({ statusCode: 500, statusMessage: message })
  }

  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Team not found' })
  }

  return teamSchema.parse(data)
})
