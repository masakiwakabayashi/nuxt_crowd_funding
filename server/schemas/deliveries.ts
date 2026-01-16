import z from 'zod'
import { optionalRelation } from './utils'
import { supporterSchema } from './supporters'
import type { DeliveryStatus } from '@/shared/types/Delivery'


export const deliveryStatusSchema = z.custom<DeliveryStatus>()

export const deliverySchema = z.object({
  id: z.string(),
  project_id: z.string(),
  reward_id: z.string(),
  supporter_id: z.string(),
  status: deliveryStatusSchema,
  created_at: z.string(),
  updated_at: z.string(),
  due_date: z.string(),
  completed_at: z.string().nullable(),
  supporter: optionalRelation(supporterSchema),
})
