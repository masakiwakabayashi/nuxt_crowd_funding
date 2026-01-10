import { getSupabaseServerClient } from '@/app/plugins/supabase.server'

export const fetchOrganizationWithProjects = async (organizationId: string) => {
  const supabase = getSupabaseServerClient()
  const { data, error } = await supabase
    .from('organizations')
    .select(`
      *,
      projects:projects(*)
    `)
    .eq('id', organizationId)
    .maybeSingle()

  if (error) {
    throw new Error(error.message)
  }

  return data
}
