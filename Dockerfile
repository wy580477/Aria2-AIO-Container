FROM alexta69/metube:latest

COPY ./content /.aria2allinoneworkdir/

ENV USER=admin
ENV PASSWORD=password
ENV DOMAIN=http://localhost
ENV EMAIL=internal
ENV WEB_PORT=8080
ENV PUID=0
ENV PGID=0
ENV ARIA_IPV6=false
ENV LANGUAGE=en
ENV PORTAL_PATH=/portal
ENV POST_MODE=move
ENV AUTO_DRIVE_NAME=true
ENV TZ=UTC
ENV RCLONE_ADDR=http://localhost:56802
ENV XDG_CONFIG_HOME=/mnt/config
ENV DOWNLOAD_DIR=/mnt/data/videos
ENV STATE_DIR=/mnt/data/videos/.metube
ENV YTDL_OPTIONS="{\"postprocessors\":[{\"key\":\"Exec\",\"exec_cmd\":\"ytdlptorclone.sh\"}],\"noprogress\":true}"
ENV YTDL_OUTPUT_TEMPLATE="%(title)s_%(uploader)s.%(ext)s"

RUN apk add --no-cache curl caddy jq aria2 bash findutils runit su-exec tzdata \
    && wget -P /.aria2allinoneworkdir https://github.com/mayswind/AriaNg/releases/download/1.2.4/AriaNg-1.2.4.zip \
    && wget -P /.aria2allinoneworkdir https://github.com/rclone/rclone-webui-react/releases/download/v2.0.5/currentbuild.zip \
    && wget -P /.aria2allinoneworkdir https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip \
    && curl -fsSL https://raw.githubusercontent.com/wy580477/filebrowser-install/master/get.sh | bash \
    && chmod +x /.aria2allinoneworkdir/service/*/run /.aria2allinoneworkdir/aria2/*.sh /.aria2allinoneworkdir/*.sh \
    && mv /.aria2allinoneworkdir/ytdlptorclone.sh /usr/bin/

VOLUME /mnt/data /mnt/config

LABEL org.opencontainers.image.authors="wy580477@outlook.com"
LABEL org.label-schema.name="Aria2-AIO-Container"
LABEL org.label-schema.description="Aria2 container with Rclone auto-upload function & more"
LABEL org.label-schema.vcs-url="https://github.com/wy580477/Aria2-AIO-Container/"

ENTRYPOINT ["sh","-c","/.aria2allinoneworkdir/entrypoint.sh"]
