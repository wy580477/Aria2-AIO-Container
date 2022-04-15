FROM alpine:latest

COPY ./content /.aria2allinoneworkdir/

ARG MODE=build

ENV USER=admin
ENV PASSWORD=password
ENV DOMAIN=http://localhost
ENV EMAIL=internal
ENV WEB_PORT=8080
ENV PUID=0
ENV PGID=0
ENV TZ=UTC
ENV ARIA_IPV6=false
ENV BT_PORT=51413
ENV LANGUAGE=en
ENV PORTAL_PATH=/portal
ENV POST_MODE=move
ENV AUTO_DRIVE_NAME=true
ENV CLEAN_UNFINISHED_FAILED_TASK_FILES=true
ENV TZ=UTC
ENV RCLONE_ADDR=http://localhost:56802

RUN apk add --no-cache curl caddy jq aria2 bash findutils runit su-exec tzdata \
    && wget -P /.aria2allinoneworkdir https://github.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip \
    && wget -P /.aria2allinoneworkdir https://github.com/rclone/rclone-webui-react/releases/latest/download/currentbuild.zip \
    && wget -P /.aria2allinoneworkdir https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip \
    && curl -fsSL https://raw.githubusercontent.com/wy580477/filebrowser-install/master/get.sh | bash \
    && chmod +x /.aria2allinoneworkdir/service/*/run /.aria2allinoneworkdir/aria2/*.sh /.aria2allinoneworkdir/*.sh

VOLUME /mnt/data /mnt/config

LABEL org.opencontainers.image.authors="wy580477@outlook.com"
LABEL org.label-schema.name="Aria2-AIO-Container"
LABEL org.label-schema.description="Aria2 container with Rclone auto-upload function & more"
LABEL org.label-schema.vcs-url="https://github.com/wy580477/Aria2-AIO-Container/"

ENTRYPOINT ["sh","-c","/.aria2allinoneworkdir/entrypoint.sh"]
