import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '../../shared/utils/supabaseServerClient'




export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const projectId = query.projectId

  if (!projectId || typeof projectId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'projectId is required',
    })
  }

  const supabase = getSupabaseServerClient()

  const { data, error, status } = await supabase
    .from('projects')
    .select(
      'id, organization_id, title, description, start_at, end_at, goal, created_at, updated_at',
    )
    .eq('id', projectId)
    .single()

  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }
  if (!data) {
    throw createError({ statusCode: 404, statusMessage: 'Project not found' })
  }

  const parsedGoal = Number(data.goal ?? 0)
  const goal = Number.isNaN(parsedGoal) ? 0 : parsedGoal

  return {
    project: {
      id: data.id,
      organizationId: data.organization_id,
      title: data.title,
      description: data.description,
      startAt: data.start_at,
      endAt: data.end_at,
      goal,
      createdAt: data.created_at,
      updatedAt: data.updated_at,
    },
  }
})
