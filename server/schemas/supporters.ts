import z from 'zod'
import { numericField } from './utils'

export const supporterSchema = z.object({
  id: z.string(),
  project_id: z.string(),
  name: z.string(),
  address: z.string().nullable(),
  email: z.string().nullable(),
  pledged_amount: numericField(),
  created_at: z.string(),
  updated_at: z.string(),
})
