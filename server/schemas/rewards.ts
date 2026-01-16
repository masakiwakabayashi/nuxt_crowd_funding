import z from 'zod'
import { numericField } from './utils'

export const rewardSchema = z.object({
  id: z.string(),
  project_id: z.string(),
  title: z.string(),
  detail: z.string().nullable(),
  max_quantity: z.number().nullable(),
  category_id: z.string().nullable(),
  price: numericField(),
  estimated_delivery: z.string().nullable(),
  created_at: z.string(),
  updated_at: z.string(),
})
