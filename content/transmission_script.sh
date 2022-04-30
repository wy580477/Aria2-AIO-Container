#!/bin/sh

DATE_TIME() {
    date +"%m/%d %H:%M:%S"
}

ECHO_INFO() {
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "$(DATE_TIME) [INFO] Successfully send job to rclone: "${TR_TORRENT_DIR}"/"${TR_TORRENT_NAME}" -> ${REMOTE_PATH}"
    else
        echo "$(DATE_TIME) [ERROR] Failed to send job to rclone: "${TR_TORRENT_DIR}"/"${TR_TORRENT_NAME}""
    fi
}

DRIVE_NAME="$(grep ^drive-name /mnt/config/aria2/script.conf | cut -d= -f2-)"
DRIVE_DIR="$(grep ^drive-dir /mnt/config/aria2/script.conf | cut -d= -f2-)"
REMOTE_PATH="${DRIVE_NAME}:${DRIVE_DIR}"

if [ -f "${TR_TORRENT_DIR}"/"${TR_TORRENT_NAME}" ]; then
    if [ "${POST_MODE}" = "move_remote" ]; then
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'","srcRemote":"'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${TR_TORRENT_NAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/movefile'
        EXIT_CODE=$?
        ECHO_INFO
    else
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'","srcRemote":"'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${TR_TORRENT_NAME}}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/copyfile'
        EXIT_CODE=$?
        ECHO_INFO
    fi
else
    if [ "${POST_MODE}" = "move_remote" ]; then
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'/'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","_async":"true"}' ''${RCLONE_ADDR}'/sync/move'
        EXIT_CODE=$?
        ECHO_INFO
    else
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'/'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","_async":"true"}' ''${RCLONE_ADDR}'/sync/copy'
        EXIT_CODE=$?
        ECHO_INFO
    fi
fi
