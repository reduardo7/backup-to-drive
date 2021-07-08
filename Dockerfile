FROM ubuntu 

RUN apt-get update && apt-get install -y curl

COPY gdrive-upload.sh /usr/local/bin/gdrive-upload

VOLUME /root/.gdrive
