#!/usr/bin/env node
import fs from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'
import { fileURLToPath } from 'node:url'
import { createClient } from '@supabase/supabase-js'

const MIME_TYPES = {
  '.pdf': 'application/pdf'
}

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const projectRoot = path.resolve(__dirname, '..')

async function loadEnvFile(envPath) {
  try {
    const raw = await fs.readFile(envPath, 'utf8')
    for (const line of raw.split(/\r?\n/)) {
      const trimmed = line.trim()
      if (!trimmed || trimmed.startsWith('#')) continue
      const eqIndex = trimmed.indexOf('=')
      if (eqIndex === -1) continue
      const key = trimmed.slice(0, eqIndex).trim()
      if (!key || key in process.env) continue
      let value = trimmed.slice(eqIndex + 1).trim()
      if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
        value = value.slice(1, -1)
      }
      process.env[key] = value
    }
  } catch (error) {
    if (error && error.code === 'ENOENT') return
    throw error
  }
}

async function ensureDirectoryExists(dir) {
  try {
    const stats = await fs.stat(dir)
    if (!stats.isDirectory()) {
      throw new Error(`${dir} exists but is not a directory`)
    }
  } catch (error) {
    if (error && error.code === 'ENOENT') {
      throw new Error(`Directory not found: ${dir}`)
    }
    throw error
  }
}

async function walkFiles(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true })
  const files = []
  for (const entry of entries) {
    if (entry.name === '.DS_Store') continue
    const fullPath = path.join(dir, entry.name)
    if (entry.isDirectory()) {
      files.push(...(await walkFiles(fullPath)))
    } else if (entry.isFile()) {
      files.push(fullPath)
    }
  }
  return files
}

function guessContentType(filePath) {
  const ext = path.extname(filePath).toLowerCase()
  return MIME_TYPES[ext] || 'application/octet-stream'
}

function ensurePdf(filePath) {
  if (path.extname(filePath).toLowerCase() !== '.pdf') {
    throw new Error(`Only PDF files are supported. Invalid file: ${filePath}`)
  }
}

async function ensureBucketExists(supabase, bucket) {
  const { data: buckets, error } = await supabase.storage.listBuckets()
  if (error) {
    throw new Error(`Failed to list buckets: ${error.message}`)
  }
  if (buckets.some(({ name }) => name === bucket)) {
    return
  }
  const { error: createError } = await supabase.storage.createBucket(bucket, { public: false })
  if (createError) {
    throw new Error(`Failed to create bucket ${bucket}: ${createError.message}`)
  }
}

function buildStoragePath(baseDir, filePath, prefix = '') {
  const relativePath = path.relative(baseDir, filePath)
  const normalized = relativePath.split(path.sep).join('/')
  if (!prefix) return normalized
  return `${prefix.replace(/\/+$/u, '')}/${normalized}`
}

async function uploadAllFiles({ supabase, bucket, baseDir, files, prefix, concurrency }) {
  let index = 0
  let uploaded = 0
  const total = files.length

  const worker = async () => {
    while (true) {
      const currentIndex = index++
      if (currentIndex >= total) break
      const filePath = files[currentIndex]
      ensurePdf(filePath)
      const storagePath = buildStoragePath(baseDir, filePath, prefix)
      const buffer = await fs.readFile(filePath)
      const { error } = await supabase.storage.from(bucket).upload(storagePath, buffer, {
        contentType: guessContentType(filePath),
        upsert: true
      })
      if (error) {
        throw new Error(`Failed to upload ${storagePath}: ${error.message}`)
      }
      uploaded += 1
      console.log(`Uploaded ${storagePath} (${uploaded}/${total})`)
    }
  }

  const workers = Array.from({ length: Math.min(concurrency, total) }, () => worker())
  await Promise.all(workers)
}

async function main() {
  await loadEnvFile(path.join(projectRoot, '.env'))

  const bucketSetting = process.env.DOCUMENTS_BUCKETS || process.env.DOCUMENTS_BUCKET || 'documents,pdfs'
  const buckets = bucketSetting
    .split(',')
    .map((name) => name.trim())
    .filter(Boolean)
  if (buckets.length === 0) {
    throw new Error('No bucket names specified. Provide DOCUMENTS_BUCKETS or DOCUMENTS_BUCKET env variable.')
  }

  const baseDir = path.resolve(projectRoot, process.env.DOCUMENTS_BASE_DIR || 'supabase/documents')
  const prefix = process.env.DOCUMENTS_PREFIX || ''
  const concurrency = Number(process.env.UPLOAD_CONCURRENCY || '5')

  await ensureDirectoryExists(baseDir)

  const supabaseUrl = process.env.NUXT_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseKey = process.env.NUXT_SUPABASE_SECRET_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_KEY

  if (!supabaseUrl || !supabaseKey) {
    throw new Error('Missing Supabase credentials. Set NUXT_SUPABASE_URL and NUXT_SUPABASE_SECRET_KEY in your environment or .env file.')
  }

  const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: { persistSession: false }
  })

  const files = await walkFiles(baseDir)
  if (files.length === 0) {
    console.log(`No files found under ${baseDir}`)
    return
  }

  for (const bucket of buckets) {
    await ensureBucketExists(supabase, bucket)
    await uploadAllFiles({ supabase, bucket, baseDir, files, prefix, concurrency })
    console.log(`Uploaded ${files.length} files to bucket ${bucket}`)
  }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
