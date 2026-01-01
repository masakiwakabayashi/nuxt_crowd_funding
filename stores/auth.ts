import { ref } from 'vue'
import { defineStore } from 'pinia'
import type { User } from '@supabase/supabase-js'
import { getSupabaseBrowserClient } from '@/shared/utils/supabaseBrowserClient'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const isInitialized = ref(false)
  const supabase = process.client ? getSupabaseBrowserClient() : null

  const setUserFromSession = (sessionUser: User | null) => {
    user.value = sessionUser
    isInitialized.value = true
  }

  const fetchSession = async () => {
    if (!supabase) return
    const { data } = await supabase.auth.getSession()
    setUserFromSession(data.session?.user ?? null)
  }

  const logout = async () => {
    if (!supabase) return
    await supabase.auth.signOut()
    user.value = null
  }

  const startAuthListener = () => {
    if (!supabase) return
    supabase.auth.onAuthStateChange((_event, session) => {
      setUserFromSession(session?.user ?? null)
    })
  }

  return {
    user,
    isInitialized,
    fetchSession,
    logout,
    startAuthListener,
  }
})
