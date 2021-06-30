# Compiler step
FROM ubuntu as compiler

RUN apt-get update && apt-get install -y wget

ARG GDRIVE_VERSION=2.1.1
COPY download-gdrive.sh /download-gdrive.sh
RUN /download-gdrive.sh

# Final image
FROM ubuntu as gdrive

COPY --from=compiler /usr/local/bin/gdrive /usr/local/bin/gdrive
COPY gdrive-sync-upload.sh /usr/local/bin/gdrive-sync-upload

VOLUME /root/.gdrive
