import { createError, readBody } from 'h3'
import z from 'zod'
import { updateProjectWithRelations } from '@/server/repositories/projectsRepository'
import { projectWithRelationsSchema } from '@/server/schemas/projects'

const parseGoalValue = (value: unknown): number | undefined => {
  if (typeof value === 'number' && Number.isFinite(value)) {
    return value
  }

  if (typeof value === 'string' && value.trim().length > 0) {
    const parsed = Number(value)
    return Number.isFinite(parsed) ? parsed : undefined
  }

  return undefined
}

const updateProjectBodySchema = z.object({
  projectId: z.string().min(1, 'projectId is required'),
  title: z.string().optional(),
  description: z.string().nullable().optional(),
  startAt: z.string().nullable().optional(),
  endAt: z.string().nullable().optional(),
  goal: z.union([z.number(), z.string()]).optional(),
}).transform((body) => ({
  ...body,
  goal: parseGoalValue(body.goal),
}))

export default defineEventHandler(async (event) => {
  const parsedBody = updateProjectBodySchema.safeParse(await readBody(event))

  if (!parsedBody.success) {
    throw createError({
      statusCode: 400,
      statusMessage: parsedBody.error.issues[0]?.message ?? 'Invalid request body',
    })
  }

  const body = parsedBody.data
  const updates: Record<string, unknown> = {}

  if (body.title !== undefined) {
    updates.title = body.title
  }

  if (body.description !== undefined) {
    updates.description = body.description
  }

  if (body.startAt !== undefined) {
    updates.start_at = body.startAt
  }

  if (body.endAt !== undefined) {
    updates.end_at = body.endAt
  }

  if (typeof body.goal === 'number') {
    updates.goal = body.goal
  }

  if (Object.keys(updates).length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: 'At least one field is required to update the project',
    })
  }

  let data
  try {
    data = await updateProjectWithRelations(body.projectId, updates)
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to update project'
    throw createError({ statusCode: 500, statusMessage: message })
  }

  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Project not found' })
  }

  return projectWithRelationsSchema.parse(data)
})
