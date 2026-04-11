#!/usr/bin/env bash
# obsidian-brain SessionStart hook
# - auto-detect Obsidian Vault path if OBSIDIAN_BRAIN_VAULT_PATH is unset
# - emit a system reminder so Claude knows the brain state
# target: <500ms, pure bash, no external deps beyond coreutils

set -u

detect_vault() {
  if [ -n "${OBSIDIAN_BRAIN_VAULT_PATH:-}" ] && [ -d "${OBSIDIAN_BRAIN_VAULT_PATH}" ]; then
    printf '%s' "${OBSIDIAN_BRAIN_VAULT_PATH}"
    return 0
  fi

  local candidates=(
    "${HOME}/Documents/Obsidian Vault/AI Brain"
    "${HOME}/Documents/Obsidian Vault"
    "${HOME}/Obsidian/AI Brain"
    "${HOME}/Obsidian"
  )

  for path in "${candidates[@]}"; do
    if [ -d "${path}" ]; then
      printf '%s' "${path}"
      return 0
    fi
  done

  local found
  found=$(find "${HOME}" -maxdepth 3 -type d -name ".obsidian" -print -quit 2>/dev/null)
  if [ -n "${found}" ]; then
    printf '%s' "$(dirname "${found}")"
    return 0
  fi

  return 1
}

vault_path="$(detect_vault || true)"

if [ -n "${vault_path}" ]; then
  export OBSIDIAN_BRAIN_VAULT_PATH="${vault_path}"
  printf '[OBSIDIAN-BRAIN] Vault detected at %s. master agent ready. Run /brain-status to inspect.\n' "${vault_path}"
else
  printf '[OBSIDIAN-BRAIN] Vault not detected. Run `obsidian-brain-doctor` to diagnose, or set OBSIDIAN_BRAIN_VAULT_PATH manually.\n'
fi

exit 0
