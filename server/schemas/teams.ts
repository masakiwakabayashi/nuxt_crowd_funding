import z from 'zod'
import { relationArray } from './utils'
import { baseProjectSchema } from './projects'

export const teamSchema = z.object({
  id: z.string(),
  name: z.string(),
  created_at: z.string(),
  updated_at: z.string(),
  projects: relationArray(baseProjectSchema),
})
