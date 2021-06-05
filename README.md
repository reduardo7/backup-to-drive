# Backup to Drive

Upload your backups to Google Drive.

## Docker

<https://hub.docker.com/reduardo7/backup-to-drive>.

### Variables

#### `FILE_PATH`

[**Required**]

Full file path.

#### `DRIVE_FOLDER_ID`

[**Required**]

Google Drive folder ID.

#### `RETRY_ON_ERROR`

[**Optional**]

Retry on error times.

_Default_: `0`.

#### `GOOGLE_CLIENT_EMAIL`

[**Required**]

Google Client e-Mail.

#### `GOOGLE_PRIVATE_KEY`

[**Required**]

Google Private Key.

#### `CRON_CONFIG`

[**Optional**]

See cron config at <https://www.npmjs.com/package/node-cron>.

```text
 # ┌────────────── second (optional)
 # │ ┌──────────── minute
 # │ │ ┌────────── hour
 # │ │ │ ┌──────── day of month
 # │ │ │ │ ┌────── month
 # │ │ │ │ │ ┌──── day of week
 # │ │ │ │ │ │
 # │ │ │ │ │ │
 # * * * * * *
```

_Default_: `null`.

### Docker example

```bash
docker run --rm \
  -v "$(pwd):/backups:ro" \
  -e FILE_PATH='/backups/backup.7z' \
  -e DRIVE_FOLDER_ID='' \
  -e RETRY_ON_ERROR=3 \
  -e GOOGLE_CLIENT_EMAIL='' \
  -e GOOGLE_PRIVATE_KEY='' \
  reduardo7/backup-to-drive:latest
```

### Docker-Compose example

```yaml
version: '3.8'

services:
  backup:
    image: reduardo7/backup-to-drive:latest
    environment:
      # CRON_CONFIG: ...
      FILE_PATH: '/backups/backup.7z'
      DRIVE_FOLDER_ID: ''
      RETRY_ON_ERROR: 3
      GOOGLE_CLIENT_EMAIL: ''
      GOOGLE_PRIVATE_KEY: ''
    volumes:
      - ./:/backups:ro
```
