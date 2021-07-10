FROM ubuntu 

RUN apt-get update && apt-get install -y curl p7zip

ENV CMD_PRE_BACKUP=''
ENV CMD_POST_BACKUP=''

ENV BACKUP_PREFIX=saves-bkp-

ENV BACKUP_DEST_DIR=/backup
RUN mkdir -p "${BACKUP_DEST_DIR}"
VOLUME /backup

ENV BACKUP_SRC_DIR=/backup_source
RUN mkdir -p "${BACKUP_SRC_DIR}"
VOLUME /backup_source
WORKDIR /backup_source

ENV BACKUP_SRC=file_or_path_to_backup

# 7200 = 2 Hrs
ENV BACKUP_INTERVAL=7200


VOLUME /root/.gdrive

COPY gdrive-upload.sh /usr/local/bin/gdrive-upload
COPY backup.sh /backup.sh

CMD /backup.sh
