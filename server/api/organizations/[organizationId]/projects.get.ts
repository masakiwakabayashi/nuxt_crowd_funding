import { createError } from 'h3'
import { getSupabaseServerClient } from '../../../../shared/utils/supabaseServerClient'

type ProjectRow = {
  id: string
  title: string
  description: string | null
  start_at: string
  end_at: string
  goal: string | number | null
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

  const { data, error } = await supabase
    .from('projects')
    .select('id, title, description, start_at, end_at, goal, created_at, updated_at')
    .eq('organization_id', organizationId)
    .order('created_at', { ascending: false })
    .returns<ProjectRow[]>()

  if (error) {
    throw createError({ statusCode: 500, statusMessage: error.message })
  }

  const projects = (data ?? []).map((project) => ({
    id: project.id,
    title: project.title,
    description: project.description,
    startAt: project.start_at,
    endAt: project.end_at,
    goal: Number(project.goal ?? 0),
    createdAt: project.created_at,
    updatedAt: project.updated_at,
  }))

  return { projects }
})
