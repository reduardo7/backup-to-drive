# Backup to Drive

Upload your backups to Google Drive.

## Docker

<https://hub.docker.com/r/reduardo7/backup-to-drive>.

## Build

```bash
docker-compose build
```

### Variables

#### `DRIVE_FOLDER_ID`

[**Required**]

Google Drive folder ID.

### Docker example

```bash
docker run --rm \
  -v "$(pwd):/backups:ro" \
  -e DRIVE_FOLDER_ID='xxx' \
  reduardo7/backup-to-drive:latest \
  gdrive-upload /backups/file-to-backup.7z
```

### Docker-Compose example

```yaml
version: '3.8'

services:
  backup:
    image: reduardo7/backup-to-drive:latest
    environment:
      DRIVE_FOLDER_ID: 'xxx'
    volumes:
      - ./:/backups:ro
    command: gdrive-upload /backups/file-to-backup.7z
```

## Initial setup

### A. Google Account setup

1. Go to
<https://console.cloud.google.com/apis/credentials>.

### B. Docker setup

1. We will need to give access to _Google Drive_ to allow this program to connect to your account. To do this, insert below command:

    ```bash
    docker run \
      -ti \
      -v $(pwd)/.data/gdrive:/root/.gdrive \
      reduardo7/backup-to-drive:latest \
      gdrive list
    ```

2. Copy the link it gives you to your browser and chooses your google drive account.
3. Click Allow button to give access.
4. Copy the generated verification code and insert into a terminal.
5. Now we are done... Let's upload a file.

    ```bash
    docker run \
      -ti \
      -v $(pwd)/.data/gdrive:/root/.gdrive \
      -v /path/to/file:/uploads/file:ro
      reduardo7/backup-to-drive:latest \
      gdrive upload /uploads/file
    ```

## References

- <https://www.serverkaka.com/2018/05/upload-file-to-google-drive-from-the-command-line-terminal.html>
- <https://github.com/prasmussen/gdrive>
