export const formatDateTime = (value: string | null | undefined): string => {
  if (!value) return ''
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''

  return new Intl.DateTimeFormat('ja-JP', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  }).format(date)
}

export const formatDisplayDate = (value: string | null | undefined): string => {
  if (!value) return ''
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  const y = date.getFullYear()
  const m = String(date.getMonth() + 1).padStart(2, '0')
  const d = String(date.getDate()).padStart(2, '0')
  return `${y}/${m}/${d}`
}

export const formatIsoDate = (value: string | null | undefined): string => {
  if (!value) return ''
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? '' : date.toISOString().split('T')[0] ?? ''
}

export const calculateRemainingDays = (
  dateString: string | null | undefined,
): number => {
  if (!dateString) return 0
  const deadlineDate = new Date(dateString)
  if (Number.isNaN(deadlineDate.getTime())) return 0
  const diff = deadlineDate.getTime() - Date.now()
  return Math.max(Math.ceil(diff / (1000 * 60 * 60 * 24)), 0)
}
