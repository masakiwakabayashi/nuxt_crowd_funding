import z from 'zod'

/**
 * サンプル
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

  const response = await $fetch(`/posts/${articleId}`, {
    baseURL,
    params: {
      _expand: 'author',
      _embed: 'tags',
    },
  })

  // 受け取ったレスポンスをスキーマでバリデーションしてから返す
  return exampleArticleSchema.parse(response)
}
