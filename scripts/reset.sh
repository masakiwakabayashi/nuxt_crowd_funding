#!/usr/bin/env bash
set -uo pipefail

fail() { echo "[error] $*" >&2; exit 1; }

# kongの公開ポート(8000/tcp)から API URL を作る（supabase status 不要）
detect_api_url_from_docker() {
  local kong mapping host port
  kong="$(docker ps --format '{{.Names}}' | grep -i 'kong' | head -n 1 || true)"
  [[ -n "${kong:-}" ]] || return 1

  mapping="$(docker port "$kong" 8000/tcp 2>/dev/null | head -n 1 || true)"
  [[ -n "${mapping:-}" ]] || return 1

  host="${mapping%:*}"
  port="${mapping##*:}"

  if [[ "$host" == "0.0.0.0" || "$host" == "::" ]]; then
    host="127.0.0.1"
  fi

  echo "http://${host}:${port}"
}

wait_until_ok() {
  local url="$1"
  local pattern="$2"
  local timeout_sec="${3:-360}"

  local deadline=$((SECONDS + timeout_sec))
  while (( SECONDS < deadline )); do
    if curl -fsS "$url" 2>/dev/null | grep -qE "$pattern"; then
      return 0
    fi
    sleep 2
  done
  return 1
}

echo "[reset] supabase db reset..."
if ! supabase db reset; then
  echo "[warn] db reset failed (possibly 502 during restarting containers). Continue to recover..."
fi

# reset失敗しても起動を試みる（起動済みなら実質ノーダメ）
echo "[start] ensure supabase is running..."
supabase start >/dev/null 2>&1 || true

API_URL="$(detect_api_url_from_docker || true)"
[[ -n "${API_URL:-}" ]] || fail "Failed to detect API URL from Docker (kong container not found or no 8000/tcp mapping)."

echo "[info] Detected API URL: $API_URL"

echo "[wait] Waiting for REST..."
if ! wait_until_ok "$API_URL/rest/v1/" "openapi|OpenAPI" 360; then
  echo "[debug] docker ps:"
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || true
  fail "REST did not become ready: $API_URL/rest/v1/"
fi
echo "[ok] REST is ready."

# ===========================
# 修正版（直し方1）：Storage は「HTTP応答が返ればOK」
# ===========================
echo "[wait] Waiting for Storage..."
deadline=$((SECONDS + 360))
while (( SECONDS < deadline )); do
  code="$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/storage/v1/bucket" || true)"

  # 000=接続失敗、502/503=ゲートウェイor上流が死んでる可能性
  # それ以外（200/401/403/404など）なら「Storage が応答している」とみなしてOK
  if [[ "$code" != "000" && "$code" != "502" && "$code" != "503" ]]; then
    echo "[ok] Storage responded (HTTP $code)."
    break
  fi

  sleep 2
done

if (( SECONDS >= deadline )); then
  echo "[debug] docker ps:"
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || true
  fail "Timed out waiting for Storage to respond."
fi

echo "[upload] Running uploader..."
set -e
npx tsx scripts/upload-documents.ts
