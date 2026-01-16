import z from 'zod'
import { optionalRelation } from './utils'
import { supporterSchema } from './supporters'

export const deliverySchema = z.object({
  id: z.string(),
  project_id: z.string(),
  reward_id: z.string(),
  supporter_id: z.string(),
  status: z.union([
    z.literal('未着手'),
    z.literal('作成中'),
    z.literal('完了'),
  ]),
  created_at: z.string(),
  updated_at: z.string(),
  due_date: z.string(),
  completed_at: z.string().nullable(),
  supporter: optionalRelation(supporterSchema),
})
