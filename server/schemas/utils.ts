import z from 'zod'

export const coerceNumber = (value: unknown, fallback = 0) => {
  if (typeof value === 'number' && Number.isFinite(value)) {
    return value
  }

  if (typeof value === 'string' && value.trim().length > 0) {
    const parsed = Number(value)
    if (Number.isFinite(parsed)) {
      return parsed
    }
  }

  return fallback
}

export const numericField = (fallback = 0) =>
  z.preprocess((value) => coerceNumber(value, fallback), z.number())

export const optionalRelation = <Schema extends z.ZodTypeAny>(schema: Schema) =>
  z.preprocess((value) => (value === null ? undefined : value), schema.optional())

export const relationArray = <Schema extends z.ZodTypeAny>(schema: Schema) =>
  z.preprocess((value) => value ?? [], z.array(schema))
