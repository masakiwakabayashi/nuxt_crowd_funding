import { useRuntimeConfig } from '#imports'
import type { NuxtApp } from 'nuxt/app'
import { createClient } from '@supabase/supabase-js'
import type { SupabaseClient } from '@supabase/supabase-js'

let browserClient: SupabaseClient | null = null

export const getSupabaseBrowserClient = (): SupabaseClient => {
  if (process.server) {
    throw new Error('getSupabaseBrowserClient should only be used on the client side')
  }

  if (browserClient) {
    return browserClient
  }

  const config = useRuntimeConfig()
  const supabaseUrl = config.public.supabaseUrl
  const supabaseKey = config.public.supabasePublishableKey

  if (!supabaseUrl || !supabaseKey) {
    throw new Error('Supabase client is not configured')
  }

  browserClient = createClient(supabaseUrl, supabaseKey, {
    auth: {
      persistSession: true,
      detectSessionInUrl: true,
    },
  })

  return browserClient
}

export default (nuxtApp: NuxtApp): void => {
  if (process.server) {
    return
  }

  const supabase = getSupabaseBrowserClient()
  nuxtApp.provide('supabaseBrowserClient', supabase)
}
