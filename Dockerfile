FROM ubuntu

RUN apt-get update && apt-get install -y wget

ARG GDRIVE_VERSION=2.1.1

# Swap 386 <=> amd64
# https://github.com/prasmussen/gdrive/issues/580

RUN cd /usr/local/bin \
  && wget https://github.com/prasmussen/gdrive/releases/download/${GDRIVE_VERSION}/gdrive_${GDRIVE_VERSION}_linux_386.tar.gz -O gdrive.tar.gz \
  && tar -zxvf gdrive.tar.gz \
  && rm -f gdrive.tar.gz \
  && chmod +x gdrive

COPY gdrive-upload.sh /usr/local/bin/gdrive-upload

VOLUME /root/.gdrive
