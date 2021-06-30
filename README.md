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

1. We will need to give access to _Google Drive_ to allow this program to connect to your account.
   To do this, insert below command:

   ```bash
   docker run \
     -ti \
     -v $(pwd)/.data/gdrive:/root/.gdrive \
     reduardo7/backup-to-drive:latest \
     gdrive list
   ```

2. Copy the **link** it gives you to your browser and chooses your _Google Drive_ account.
3. Click **Allow** button to give access.
4. Copy the **generated verification code** and insert into a **terminal**.
5. Now we are done... Let's upload a file.

   ```bash
   docker run \
     -ti \
     -v $(pwd)/.data/gdrive:/root/.gdrive \
     -v /path/to/file:/uploads/file:ro \
     reduardo7/backup-to-drive:latest \
     gdrive upload /uploads/file
   ```

## Available _Google Drive_ commands

### `gdrive`

See official [`gdrive` usage documentation](https://github.com/prasmussen/gdrive#usage).

### `gdrive-sync-upload`

**Upload and sync** a directory to specific _Google Drive_ **folder ID** defined with the
[`DRIVE_FOLDER_ID`](#drive_folder_id) [environment variable](#environment-variables).

> **WARNING**: This will delete files on the directory defined at [`DRIVE_FOLDER_ID`](#drive_folder_id)!
> Please **be careful**!

- **Required Environment Variables:**
  - [`DRIVE_FOLDER_ID`](#drive_folder_id): See [`DRIVE_FOLDER_ID`](#drive_folder_id) documentation
    at [environment variables section](#environment-variables).
- **Arguments:**
  1. `sync_path`: Full directory path to upload in the current _Docker container environment_.

## Where to Store Data

This image defines a volume for `/root/.gdrive` for **_Google_ token storage**.

## Docker example

```bash
docker run --rm \
  -v $(pwd)/.data/gdrive:/root/.gdrive \
  -v "$(pwd):/backups:ro" \
  -e DRIVE_FOLDER_ID='xxx' \
  reduardo7/backup-to-drive:latest \
  gdrive-sync-upload /backups/file-to-backup.7z
```

## Docker-Compose example

```yaml
version: "3.8"

services:
  backup:
    image: reduardo7/backup-to-drive:latest
    environment:
      DRIVE_FOLDER_ID: "xxx"
    volumes:
      - ./.data/gdrive:/root/.gdrive
      - ./:/backups:ro
    command: gdrive-sync-upload /backups/file-to-backup.7z
```

## References

- <https://www.serverkaka.com/2018/05/upload-file-to-google-drive-from-the-command-line-terminal.html>
- <https://github.com/prasmussen/gdrive>
