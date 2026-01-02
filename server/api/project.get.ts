import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '@/shared/utils/supabaseServerClient'
import type { Project } from '@/shared/types/Projects'

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

  const { data, error } = await supabase
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
  }

  return project
})
