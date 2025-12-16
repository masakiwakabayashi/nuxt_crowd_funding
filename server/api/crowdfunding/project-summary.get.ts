import { createError, getQuery } from 'h3'
import { getSupabaseServerClient } from '../../../shared/utils/supabaseClient'

type ProjectRow = {
  id: string
  title: string
  description: string | null
  start_at: string
  end_at: string
  goal: string | number
}

type SupporterRow = {
  pledged_amount: string | number | null
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const organizationId = query.organizationId

  if (!organizationId || typeof organizationId !== 'string') {
    throw createError({
      statusCode: 400,
      statusMessage: 'organizationId (UUID) is required',
    })
  }

  const supabase = getSupabaseServerClient()

  const { data: project, error: projectError } = await supabase
    .from('projects')
    .select('id, title, description, start_at, end_at, goal')
    .eq('organization_id', organizationId)
    .order('start_at', { ascending: true })
    .limit(1)
    .maybeSingle<ProjectRow>()

  if (projectError) {
    throw createError({ statusCode: 500, statusMessage: projectError.message })
  }

  if (!project) {
    return { project: null }
  }

  const { data: supporters, error: supportersError } = await supabase
    .from('supporters')
    .select('pledged_amount')
    .eq('project_id', project.id)
    .returns<SupporterRow[]>()

  if (supportersError) {
    throw createError({ statusCode: 500, statusMessage: supportersError.message })
  }

  const totalSales = (supporters ?? []).reduce((sum, supporter) => {
    const amount = Number(supporter.pledged_amount ?? 0)
    return sum + (Number.isNaN(amount) ? 0 : amount)
  }, 0)

  return {
    project: {
      id: project.id,
      title: project.title,
      description: project.description,
      startAt: project.start_at,
      endAt: project.end_at,
      goal: Number(project.goal ?? 0),
      supporterCount: supporters?.length ?? 0,
      totalSales,
    },
  }
})
