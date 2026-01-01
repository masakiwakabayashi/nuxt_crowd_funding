import { createRequire } from 'node:module'
import { useRuntimeConfig } from '#imports'
import type { SupabaseClient } from '@supabase/supabase-js'

// TODO: ここがこれでいいのかは、また考える

type SupabaseLib = typeof import('@supabase/supabase-js')

const require = createRequire(import.meta.url)
const { createClient } = require('@supabase/supabase-js') as SupabaseLib

let cachedClient: SupabaseClient | null = null

export const getSupabaseServerClient = (): SupabaseClient => {
  if (cachedClient) {
    return cachedClient
  }

  const config = useRuntimeConfig()
  const supabaseUrl = config.public.supabaseUrl
  const supabaseKey = config.supabaseSecretKey || config.public.supabasePublishableKey

  if (!supabaseUrl || !supabaseKey) {
    throw new Error('Supabase credentials are not configured')
  }

  cachedClient = createClient(supabaseUrl, supabaseKey, {
    auth: {
      persistSession: false,
    },
  })

  return cachedClient
}
