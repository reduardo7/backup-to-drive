#!/usr/bin/env bash

set -x
set +e

while true; do
  ( set -e
    export BACKUP_TIMESTAMP="$(date +%s)"
    export BACKUP_FILE_NAME="${BACKUP_PREFIX}${BACKUP_TIMESTAMP}"

    [ -z "${CMD_PRE_BACKUP}" ] || eval "${CMD_PRE_BACKUP}"

    local bkp_dest_full_path="${BACKUP_DEST_DIR}/${BACKUP_FILE_NAME}"

    if [ -f "${bkp_dest_full_path}" ] || [ -d "${bkp_dest_full_path}" ]; then
      rm -rf "${bkp_dest_full_path}" || true
    fi

    cp -vrp \
      "${BACKUP_SRC_DIR}/${BACKUP_SRC}" \
      "${bkp_dest_full_path}"

    cd "${BACKUP_DEST_DIR}"
    rm -rf ${BACKUP_PREFIX}*.7z || true
    7zr a -r "${BACKUP_FILE_NAME}.7z" "${BACKUP_FILE_NAME}"
    gdrive-upload "${bkp_dest_full_path}.7z"
    rm -rf ${BACKUP_PREFIX}*.7z || true

    [ -z "${CMD_POST_BACKUP}" ] || eval "${CMD_POST_BACKUP}"
  ) || true
  
  # 7200 = 2 Hrs
  sleep ${BACKUP_INTERVAL:-7200}
done
