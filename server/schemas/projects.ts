import z from 'zod'
import { numericField, relationArray } from './utils'
import { rewardSchema } from './rewards'
import { deliverySchema } from './deliveries'

export const baseProjectSchema = z.object({
  id: z.string(),
  organization_id: z.string(),
  title: z.string(),
  description: z.string().nullable(),
  start_at: z.string(),
  end_at: z.string(),
  goal: numericField(),
  created_at: z.string(),
  updated_at: z.string(),
})

export const projectWithRelationsSchema = baseProjectSchema.extend({
  rewards: relationArray(rewardSchema),
  deliveries: relationArray(deliverySchema),
})
