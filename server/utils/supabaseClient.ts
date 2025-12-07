import { createClient, type SupabaseClient } from '@supabase/supabase-js'
import { useRuntimeConfig } from '#imports'

let cachedClient: SupabaseClient | null = null

export const getSupabaseServerClient = (): SupabaseClient => {
  if (cachedClient) {
    return cachedClient
  }

  const config = useRuntimeConfig()
  const url = config.public.supabaseUrl
  const key = config.supabaseServiceKey || config.public.supabaseAnonKey

  if (!url || !key) {
    throw new Error('Supabase credentials are not configured')
  }

  cachedClient = createClient(url, key, {
    auth: {
      persistSession: false,
    },
  })

  return cachedClient
}
