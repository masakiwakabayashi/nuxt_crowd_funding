import { createError, getQuery } from 'h3'
import { fetchDeliveriesByProjectId } from '@/server/repositories/deliveriesRepository'

// 全体的にAPIの書き方をなんとかしたい
// あとリポジトリも使う
// validatorsにzodのファイルを入れる

interface DeliveryQuery {
  projectId?: string | string[]
  page?: string | string[]
  itemsPerPage?: string | string[]
}

const toPositiveInteger = (value: string | string[] | undefined, defaultValue: number, maxValue?: number) => {
  const normalized = Array.isArray(value) ? value[0] : value
  const parsed = Number.parseInt(normalized ?? '', 10)
  const fallback = defaultValue

  if (!Number.isFinite(parsed) || parsed <= 0) {
    return fallback
  }

  if (typeof maxValue === 'number') {
    return Math.min(parsed, maxValue)
  }

  return parsed
}

export default defineEventHandler(async (event) => {
  const query = getQuery(event) as DeliveryQuery
  const projectId = Array.isArray(query.projectId) ? query.projectId[0] : query.projectId

  if (!projectId) {
    throw createError({ statusCode: 400, statusMessage: 'projectId is required' })
  }

  const page = toPositiveInteger(query.page, 1)
  const itemsPerPage = toPositiveInteger(query.itemsPerPage, 20, 100)
  const from = (page - 1) * itemsPerPage
  const to = from + itemsPerPage - 1

  try {
    const { deliveries, totalDeliveries } = await fetchDeliveriesByProjectId(projectId, { from, to })

    return {
      deliveries,
      totalDeliveries,
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to fetch deliveries'
    throw createError({ statusCode: 500, statusMessage: message })
  }
})
