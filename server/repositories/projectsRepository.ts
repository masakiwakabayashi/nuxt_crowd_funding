import { getSupabaseServerClient } from '@/app/plugins/supabase.server'

const PROJECT_SELECT = `
  *,
  rewards:rewards(*),
  deliveries:deliveries(
    *,
    supporter:supporters(*)
  )
`

export const fetchProjectWithRelations = async (projectId: string) => {
  const supabase = getSupabaseServerClient()
  const { data, error } = await supabase
    .from('projects')
    .select(PROJECT_SELECT)
    .eq('id', projectId)
    .single()

  if (error) {
    throw new Error(error.message)
  }

  return data
}

export const updateProjectWithRelations = async (
  projectId: string,
  updates: Record<string, unknown>,
) => {
  const supabase = getSupabaseServerClient()
  const { data, error } = await supabase
    .from('projects')
    .update(updates)
    .eq('id', projectId)
    .select(PROJECT_SELECT)
    .single()

  if (error) {
    throw new Error(error.message)
  }

  return data
}
