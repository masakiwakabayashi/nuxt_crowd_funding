import { createError } from 'h3'
import z from 'zod'

/**
 * APIのサンプル
 */

const exampleArticleSchema = z.object({
  id: z.number(),
  title: z.string(),
  body: z.string(),
  author: z.object({
    id: z.number(),
    name: z.string(),
  }),
  tags: z.array(z.string()).default([]),
})

export type ExampleArticle = z.infer<typeof exampleArticleSchema>

export const getExampleArticle = async (articleId: number): Promise<ExampleArticle> => {
  const baseURL = 'https://jsonplaceholder.typicode.com'

  try {
    const response = await $fetch(`/posts/${articleId}`, {
      baseURL,
      params: {
        _expand: 'author',
        _embed: 'tags',
      },
    })

    // 受け取ったレスポンスをスキーマでバリデーションしてから返す
    return exampleArticleSchema.parse(response)
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Failed to fetch sample article'
    throw createError({ statusCode: 500, statusMessage: message })
  }
}
