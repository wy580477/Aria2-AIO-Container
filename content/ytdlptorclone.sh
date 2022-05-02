#!/bin/sh

DATE_TIME() {
    date +"%m/%d %H:%M:%S"
}

DRIVE_NAME="$(grep ^drive-name /mnt/config/aria2/script.conf | cut -d= -f2-)"
DRIVE_DIR="$(grep ^drive-dir /mnt/config/aria2/script.conf | cut -d= -f2-)"
REMOTE_PATH="${DRIVE_NAME}:${DRIVE_DIR}"
FILEPATH=$(echo $1 | sed 's:[^/]*$::')
FILENAME=$(basename "$1")
mv "$1" "${FILEPATH}""${FILENAME}"

if [ "${POST_MODE}" = "move" ]; then
    :
elif [[ "${POST_MODE}" =~ "move" ]]; then
    curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${FILEPATH}"'","srcRemote":"'"${FILENAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${FILENAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/movefile'
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "$(DATE_TIME) [INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
    else
        echo "$(DATE_TIME) [ERROR] Failed to send job to rclone: $1"
    fi
elif [[ "${POST_MODE}" =~ "copy" ]]; then
    curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${FILEPATH}"'","srcRemote":"'"${FILENAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${FILENAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/copyfile'
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "$(DATE_TIME) [INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
    else
        echo "$(DATE_TIME) [ERROR] Failed to send job to rclone: $1"
    fi
fi
