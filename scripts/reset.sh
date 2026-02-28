#!/usr/bin/env bash
set -euo pipefail

supabase db reset
sleep 30
npx tsx scripts/upload-documents.ts
