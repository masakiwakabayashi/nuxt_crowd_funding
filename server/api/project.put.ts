import { createError, readBody } from 'h3'
import type { Project } from '@/shared/types/Project'
import { updateProjectWithRelations } from '@/server/repositories/projectsRepository'

interface UpdateProjectBody {
  projectId?: string
  title?: string
  description?: string | null
  startAt?: string | null
  endAt?: string | null
  goal?: number
}

const parseGoal = (value: unknown): number | undefined => {
  if (typeof value === 'number' && !Number.isNaN(value)) {
    return value
  }
  if (typeof value === 'string' && value.trim().length > 0) {
    const parsed = Number(value)
    return Number.isNaN(parsed) ? undefined : parsed
  }
  return undefined
}

const mapProject = (data: any): Project => {
  const parsedGoal = Number(data.goal ?? 0)
  const goal = Number.isNaN(parsedGoal) ? 0 : parsedGoal

  return {
    id: data.id,
    organization_id: data.organization_id,
    title: data.title,
    description: data.description,
    start_at: data.start_at,
    end_at: data.end_at,
    goal,
    created_at: data.created_at,
    updated_at: data.updated_at,
    rewards: data.rewards,
    deliveries: data.deliveries,
  }
}

export default defineEventHandler(async (event) => {
  const body = await readBody<UpdateProjectBody>(event)

  if (!body?.projectId || typeof body.projectId !== 'string') {
    throw createError({ statusCode: 400, statusMessage: 'projectId is required' })
  }

  const updates: Record<string, any> = {}

  if (typeof body.title === 'string') {
    updates.title = body.title
  }

  if (typeof body.description === 'string' || body.description === null) {
    updates.description = body.description
  }

  if (body.startAt === null || typeof body.startAt === 'string') {
    updates.start_at = body.startAt
  }

  if (body.endAt === null || typeof body.endAt === 'string') {
    updates.end_at = body.endAt
  }

  const goal = parseGoal(body.goal)
  if (typeof goal === 'number') {
    updates.goal = goal
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

  return mapProject(data)
})
