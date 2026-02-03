#!/usr/bin/env bash
set -euo pipefail

# Determine the repository root relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SUPABASE_DIR="$PROJECT_ROOT"

if ! command -v supabase >/dev/null 2>&1; then
  echo "Supabase CLI is not installed or not on PATH." >&2
  exit 1
fi

echo "[reset] Resetting Supabase database..."
supabase db reset --workdir "$SUPABASE_DIR" --yes

run_upload() {
  if command -v yarn >/dev/null 2>&1; then
    yarn --cwd "$PROJECT_ROOT" upload:documents
  else
    (cd "$PROJECT_ROOT" && npx tsx scripts/upload-documents.ts)
  fi
}

echo "[reset] Uploading documents to Supabase storage..."
run_upload

echo "[reset] Done."
