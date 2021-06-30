#!/usr/bin/env bash

# Swap 386 <=> amd64
# https://github.com/prasmussen/gdrive/issues/580

set +e

_download() {
  cd /usr/local/bin
  [ ! -f gdrive ] || rm -f gdrive
  wget https://github.com/prasmussen/gdrive/releases/download/${GDRIVE_VERSION}/gdrive_${GDRIVE_VERSION}_linux_${1}.tar.gz -O gdrive.tar.gz
  tar -zxvf gdrive.tar.gz
  rm -f gdrive.tar.gz
  chmod +x gdrive
  # Check if it is working...
  echo "Checking gdrive (${1})..."
  ./gdrive help >/dev/null || return 1
  echo "gdrive (${1}) ok!"
}

set -x

_download amd64 || _download 386
exit $?
