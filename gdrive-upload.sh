#!/usr/bin/env bash

# https://towardsdatascience.com/uploading-files-to-google-drive-directly-from-the-terminal-using-curl-2b89db28bb06

# Require "curl"
#   $ sudo apt install curl # Linux Debian/Ubuntu
#   $ brew install curl     # Mac

_err() {
  echo >&2 "Error! $*"
  exit 1
}

type curl >/dev/null 2>/dev/null || _err '"curl" is required! Install it before continue'

file="$1"
[ -f "${file}" ] || _err "Usage: $0 path/to/file.ext"

name="$(basename ${file})"
[ ! -z "${name}" ] || _err "No valid file name? Usage: $0 path/to/file.ext"

################################
# Owner information goes here! #
################################

# 1. Go to https://console.developers.google.com/apis/credentials?pli=1
# 2. After this has been done we select the Credentials tab (on the left) and “create credentials” from the top.
# 3. When asked for the app type, we select "TV and other".
# 4. Finally, this generates a "client id" and a "client seacret".
# 5. Go to https://console.cloud.google.com/apis/credentials/consent and make it "publicated".
# 6. Enable Google Drive API at https://console.cloud.google.com/apis/library/drive.googleapis.com

export GDRIVE_CLIENT_ID="${GDRIVE_CLIENT_ID}"
export GDRIVE_CLIENT_SECRET="${GDRIVE_CLIENT_SECRET}"
export GDRIVE_FOLDER_ID="${GDRIVE_FOLDER_ID}"
export GDRIVE_ACCESS_TOKEN="${GDRIVE_ACCESS_TOKEN}"

export CONFIG_DIR="${HOME}/.gdrive"
export CONFIG_FILE="${CONFIG_DIR}/config.env"

##############################

set +xe

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

_json() {
  local json="$1"
  json="${json//\": /=}"
  json="${json//  \"/export }"
  json="${json//,/}"
  json="${json//\{/}"
  json="${json//\}/}"
  echo $json
}

_waitForAuth() {
  while true; do
    response="$(
      curl \
        -d "client_id=${GDRIVE_CLIENT_ID}" \
        -d "client_secret=${GDRIVE_CLIENT_SECRET}" \
        -d "device_code=${device_code}" \
        -d 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Adevice_code' \
        https://accounts.google.com/o/oauth2/token 2>/dev/null
    )"
    eval $(_json "${response}")
    
    if [ -z "${access_token}" ]; then
      # Waiting...
      sleep 3
    else
      return
    fi
  done
}

_getToken() {
  response="$(
    curl \
      -d "client_id=${GDRIVE_CLIENT_ID}&scope=https://www.googleapis.com/auth/drive.file" \
      https://oauth2.googleapis.com/device/code 2>/dev/null
  )"
  eval $(_json "${response}")

  [ ! -z "${user_code}" ] || _err '"user_code" is not present'
  [ ! -z "${verification_url}" ] || _err '"verification_url" is not present'

  echo "Enter '${user_code}' at ${verification_url}..."

  _waitForAuth

  # Save token
  echo "GDRIVE_ACCESS_TOKEN=${access_token}" >"${CONFIG_FILE}"
  export GDRIVE_ACCESS_TOKEN="${access_token}"
}

if [ -z "${GDRIVE_ACCESS_TOKEN}" ]; then
  if [ -f "${CONFIG_FILE}" ]; then
    # Load token from file
    eval "$(cat "${CONFIG_FILE}")"

    if [ -z "${GDRIVE_ACCESS_TOKEN}" ]; then
      _getToken
    fi
  else
    _getToken
  fi
fi

curl -X POST -L \
  -H "Authorization: Bearer ${GDRIVE_ACCESS_TOKEN}" \
  -F "metadata={\
    \"title\": \"${name}\", \
    \"name\": \"${name}\", \
    \"parents\": [\"${GDRIVE_FOLDER_ID}\"] \
  };type=application/json;charset=UTF-8" \
  -F "file=@${file}" \
  'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart'

echo Done
