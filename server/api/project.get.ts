import { createError, getQuery } from 'h3'
import type { Project } from '@/shared/types/Project'
import { fetchProjectWithRelations } from '@/server/repositories/projectsRepository'

// もう少しわかりやすい感じに修正する

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const projectId = query.projectId

  if (!projectId || typeof projectId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'projectId is required',
    })
  }

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

  const parsedGoal = Number(data.goal ?? 0)
  const goal = Number.isNaN(parsedGoal) ? 0 : parsedGoal

  const project: Project = {
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

  return project
});
