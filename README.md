# Backup to Drive

Upload your backups to Google Drive.

## Docker

<https://hub.docker.com/r/reduardo7/backup-to-drive>.

## Build

```bash
docker-compose build
```

## Environment Variables

### `DRIVE_FOLDER_ID`

**Required only** by [`gdrive-sync-upload` script](#gdrive-sync-upload).

_Google Drive_ folder _ID_ where the file will be stored using [`gdrive-sync-upload` script](#gdrive-sync-upload).

You need to create a _directory_ into your _Google Drive_ account manually. Then, you should
get the **ID** from the last part of the URL like following example:
`https://drive.google.com/drive/u/0/folders/XSp4Kh15zjxYeS_u0X3QrHp-`, where `XSp4Kh15zjxYeS_u0X3QrHp-`
is the **folder ID**.

## Initial setup

1. Go to <https://console.developers.google.com/apis/credentials?pli=1>
2. After this has been done we select the Credentials tab (on the left) and “create credentials” from the top.
3. When asked for the app type, we select "TV and other".
4. Finally, this generates a "client id" and a "client seacret".
5. Go to <https://console.cloud.google.com/apis/credentials/consent> and make it "publicated".
6. Enable Google Drive API at <https://console.cloud.google.com/apis/library/drive.googleapis.com>.

## Where to Store Data

This image defines a volume for `/root/.gdrive` for **_Google_ token storage**.

## Docker example

```bash
docker run --rm \
  -v $(pwd)/.data/gdrive:/root/.gdrive \
  -v "$(pwd)/backups:/backups:ro" \
  -e GDRIVE_CLIENT_ID='[your GDRIVE_CLIENT_ID]' \
  -e GDRIVE_CLIENT_SECRET='[your GDRIVE_CLIENT_SECRET]' \
  -e GDRIVE_FOLDER_ID='[your GDRIVE_FOLDER_ID]' \
  reduardo7/backup-to-drive:latest \
  gdrive-upload /backups/file.7z
```

## Docker-Compose example

```yaml
version: "3.8"

services:
  backup:
    image: reduardo7/backup-to-drive:latest
    environment:
      GDRIVE_CLIENT_ID: '[your GDRIVE_CLIENT_ID]'
      GDRIVE_CLIENT_SECRET: '[your GDRIVE_CLIENT_SECRET]'
      GDRIVE_FOLDER_ID: '[your GDRIVE_FOLDER_ID]'
    volumes:
      - ./.data/gdrive:/root/.gdrive
      - ./backups:/backups:ro
    command: gdrive-upload /backups/file.7z
```

## References

- <https://www.serverkaka.com/2018/05/upload-file-to-google-drive-from-the-command-line-terminal.html>
- <https://github.com/prasmussen/gdrive>
