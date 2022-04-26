#!/bin/sh

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${DRIVE_NAME}" = "auto" ]; then
    DRIVENAME=${DRIVE_NAME_AUTO}
else
    DRIVENAME=${DRIVE_NAME}
fi

DRIVE_DIR="$(grep ^drive-dir /mnt/config/aria2/script.conf | cut -d= -f2-)"
FILEPATH=$(echo $1 | sed 's:[^/]*$::')
FILENAME=$(echo $1 | sed 's:/.*/::')

if [[ "${POST_MODE}" =~ "move" ]]; then
    curl -s -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${FILEPATH}"'","srcRemote":"'"${FILENAME}"'","dstFs":"'"${DRIVENAME}"':'"${DRIVE_DIR}"'","dstRemote":"'"${FILENAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/movefile'
elif [[ "${POST_MODE}" =~ "copy" ]]; then
    curl -s -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${FILEPATH}"'","srcRemote":"'"${FILENAME}"'","dstFs":"'"${DRIVENAME}"':'"${DRIVE_DIR}"'","dstRemote":"'"${FILENAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/copyfile'
fi