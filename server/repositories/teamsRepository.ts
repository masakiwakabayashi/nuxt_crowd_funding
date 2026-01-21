import { getSupabaseServerClient } from '@/app/plugins/supabase.server'

export const fetchTeamWithProjects = async (teamId: string) => {
  const supabase = getSupabaseServerClient()
  const { data, error } = await supabase
    .from('teams')
    .select(`
      *,
      projects:projects(*)
    `)
    .eq('id', teamId)
    .maybeSingle()

  if (error) {
    throw new Error(error.message)
  }

  return data
}
