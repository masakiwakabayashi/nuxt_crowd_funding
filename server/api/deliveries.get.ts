import { createError, getQuery } from 'h3'
import z from 'zod'
import { fetchDeliveriesByProjectId } from '@/server/repositories/deliveriesRepository'
import { deliverySchema } from '@/server/schemas/deliveries'

// テーブルを見直す
// https://docs.google.com/spreadsheets/d/1dKkgna5v09tAtruAuIljwdfYwENku_CQH5VLWuAE3WA/edit?gid=2044384052#gid=2044384052


const singleQueryValue = (value: unknown): string | undefined => {
  if (Array.isArray(value)) {
    return typeof value[0] === 'string' ? value[0] : undefined
  }

  return typeof value === 'string' ? value : undefined
}

const positiveIntegerSchema = (defaultValue: number, maxValue?: number) =>
  z.preprocess((value) => {
    const normalized = singleQueryValue(value)
    const parsed = normalized ? Number.parseInt(normalized, 10) : Number.NaN

    if (!Number.isFinite(parsed) || parsed <= 0) {
      return defaultValue
    }

    if (typeof maxValue === 'number') {
      return Math.min(parsed, maxValue)
    }

    return parsed
  }, z.number().int().positive())

const deliveriesQuerySchema = z.object({
  projectId: z.preprocess(
    (value) => singleQueryValue(value) ?? '',
    z.string().min(1, 'projectId is required'),
  ),
  page: positiveIntegerSchema(1),
  itemsPerPage: positiveIntegerSchema(20, 100),
})

const deliveriesResponseSchema = z.object({
  deliveries: z.array(deliverySchema),
  totalDeliveries: z.number().int().nonnegative(),
})

export default defineEventHandler(async (event) => {
  const parsedQuery = deliveriesQuerySchema.safeParse(getQuery(event))

  if (!parsedQuery.success) {
    throw createError({
      statusCode: 400,
      statusMessage: parsedQuery.error.issues[0]?.message ?? 'Invalid query parameters',
    })
  }

  const { projectId, page, itemsPerPage } = parsedQuery.data
  const from = (page - 1) * itemsPerPage
  const to = from + itemsPerPage - 1

  let data
  try {
    data = await fetchDeliveriesByProjectId(projectId, { from, to })
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to fetch deliveries'
    throw createError({ statusCode: 500, statusMessage: message })
  }

  return deliveriesResponseSchema.parse(data)
})
