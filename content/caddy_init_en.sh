#!/bin/bash

if [ "${ARIA_IPV6}" = "true" ]; then
    MESSAGE3="Enabled"
else 
    MESSAGE3="Disabled"
fi

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${DRIVE_NAME}" = "auto" ]; then
    DRIVENAME=${DRIVE_NAME_AUTO}
fi

BT_PORT="$(grep ^listen-port /mnt/config/aria2/aria2.conf | cut -d= -f2-)"
sed -i "s|MESSAGE3|${MESSAGE3}|g" /.aria2allinoneworkdir/homer/assets/config.yml
sed -i "s|BT_PORT|${BT_PORT}|g" /.aria2allinoneworkdir/homer/assets/config.yml

if [ "${POST_MODE}" = "dummy" ]; then
    sed -i "s|MODE_STATUS|</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "move" ]; then
    sed -i "s|MODE_STATUS|<br />Aria Event Hook mode:<br />[move] Move files to local finished folder after download completed</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "custom" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook mode: [custom] </b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ ! -f "/mnt/config/rclone.conf" ]; then
    sed -i "s|MODE_STATUS|<br />Aria Event Hook mode:<br />rclone.conf file not found in config dir</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "copy_remote" ]; then
    sed -i "s|MODE_STATUS|<br />Aria Event Hook mode:<br />[copy_remote] Move files to local finished folder after both download and seeding completed, then copy to Rclone remote ${DRIVENAME}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "copy_remote_first" ]; then
    sed -i "s|MODE_STATUS|<br />Aria Event Hook mode:<br />[copy_remote_first] Copy files to Rclone remote ${DRIVENAME} after download completed, triggerd before seeding for Bittorrent task</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "move_remote" ]; then
    sed -i "s|MODE_STATUS|<br />Aria Event Hook mode:<br />[move_remove] Move files to local finished folder after both download and seeding completed, then move to Rclone remote ${DRIVENAME}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "move_remote_only" ]; then
    sed -i "s|MODE_STATUS|<br />Aria Event Hook mode:<br />[move_remote_only] Move files to Rclone remote ${DRIVENAME} after both download and seeding completed</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
fi
