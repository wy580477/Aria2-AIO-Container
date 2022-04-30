#!/bin/sh

DRIVE_NAME="$(grep ^drive-name /mnt/config/aria2/script.conf | cut -d= -f2-)"
DRIVE_DIR="$(grep ^drive-dir /mnt/config/aria2/script.conf | cut -d= -f2-)"
REMOTE_PATH="${DRIVE_NAME}:${DRIVE_DIR}"

if [ -f "${TR_TORRENT_DIR}"/"${TR_TORRENT_NAME}" ]; then
    if [ "${POST_MODE}" = "move_remote" ]; then
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'","srcRemote":"'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${TR_TORRENT_NAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/movefile'
    else
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'","srcRemote":"'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${TR_TORRENT_NAME}}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/copyfile'
    fi
else
    if [ "${POST_MODE}" = "move_remote" ]; then
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'/'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","_async":"true"}' ''${RCLONE_ADDR}'/sync/move'
    else
        curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${TR_TORRENT_DIR}"'/'"${TR_TORRENT_NAME}"'","dstFs":"'"${REMOTE_PATH}"'","_async":"true"}' ''${RCLONE_ADDR}'/sync/copy'
    fi
fi
