#!/usr/bin/env bash

_err() {
  echo >&2 "Missing ${1} configuration variable!"
  echo >&2 "Usage:"
  echo >&2 "  $ DRIVE_FOLDER_ID=xxx ${0} [FILE_PATH]"
  exit 1
}

FILE_PATH="${2}"

[ -z "${DRIVE_FOLDER_ID}" ] || _err DRIVE_FOLDER_ID
[ -z "${FILE_PATH}" ] || _err FILE_PATH

# https://github.com/prasmussen/gdrive#upload-file-or-directory
gdrive upload \
  -r \
  -p ${DRIVE_FOLDER_ID} \
  ${FILE_PATH}
