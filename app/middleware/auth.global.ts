import { defineNuxtRouteMiddleware, navigateTo } from '#app'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@/stores/auth'

const LOGIN_PATH = '/login'
const DASHBOARD_PATH = '/'

export default defineNuxtRouteMiddleware(async (to) => {
  if (process.server) {
    return
  }

  const authStore = useAuthStore()
  const { user, isInitialized } = storeToRefs(authStore)

  if (!isInitialized.value) {
    try {
      await authStore.fetchSession()
    } catch (error) {
      console.error('Failed to fetch auth session', error)
    }
  }

  const isAuthenticated = Boolean(user.value)
  const isLoginRoute = to.path === LOGIN_PATH

  if (!isAuthenticated && !isLoginRoute) {
    return navigateTo(LOGIN_PATH, { replace: true })
  }

  if (isAuthenticated && isLoginRoute) {
    return navigateTo(DASHBOARD_PATH, { replace: true })
  }
})
