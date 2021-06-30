#!/usr/bin/env bash

script_name="$0"
sync_path="${1}"

_err() {
  echo >&2
  echo >&2 "Missing '${1}' configuration variable!"
  echo >&2
  echo >&2 "Usage:"
  echo >&2 "  $ DRIVE_FOLDER_ID=xxx ${script_name} [sync_path]"
  echo >&2
  exit 1
}

[ -z "${DRIVE_FOLDER_ID}" ] || _err DRIVE_FOLDER_ID
[ -z "${sync_path}" ] || _err sync_path

# https://github.com/prasmussen/gdrive#upload-file-or-directory
gdrive sync upload \
  --keep-local \
  "${sync_path}" \
  "${DRIVE_FOLDER_ID}"
