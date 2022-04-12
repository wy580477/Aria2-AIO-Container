#!/bin/bash

if [ "${ARIA_IPV6}" = "true" ]; then
    MESSAGE3="已启用"
else 
    MESSAGE3="未启用"
fi

if [ "${CLEAN_UNFINISHED_FAILED_TASK_FILES}" = "true" ]; then
    MESSAGE1="已启用"
else 
    MESSAGE1="未启用"
fi

if [ "${AUTO_DELETE_UNWANTED}" = "true" ]; then
    MESSAGE2="已启用"
else 
    MESSAGE2="未启用"
fi

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${DRIVE_NAME}" = "auto" ]; then
    DRIVENAME=${DRIVE_NAME_AUTO}
else 
    DRIVENAME=${DRIVE_NAME}
fi

sed -i "s|MESSAGE1|${MESSAGE1}|g" /.aria2allinoneworkdir/homer/assets/config.yml
sed -i "s|MESSAGE2|${MESSAGE2}|g" /.aria2allinoneworkdir/homer/assets/config.yml
sed -i "s|MESSAGE3|${MESSAGE3}|g" /.aria2allinoneworkdir/homer/assets/config.yml
sed -i "s|BT_PORT|${BT_PORT}|g" /.aria2allinoneworkdir/homer/assets/config.yml

if [ "${POST_MODE}" = "dummy" ]; then
    sed -i "s|MODE_STATUS|</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "move" ]; then
    sed -i "s|MODE_STATUS|<br />[move] 下载任务完成后移动到本地 finished 目录</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "custom" ]; then
    sed -i "s|<br />自动清理多余文件: MESSAGE2<br />自动删除错误或已移除未完成下载任务文件: MESSAGE1MODE_STATUS|<br />Aria2自动化模式: [custom] 自定义</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ ! -f "/mnt/config/rclone.conf" ]; then
    sed -i "s|MODE_STATUS|<br />Rclone 联动模式:<br />config 目录下未找到 rclone.conf 配置文件</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "copy_remote" ]; then
    sed -i "s|MODE_STATUS|<br />Rclone 联动模式:<br />[copy_remote] 下载及做种完成后移动到本地finished目录, 然后复制到${DRIVENAME}:${DRIVE_DIR}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "copy_remote_first" ]; then
    sed -i "s|MODE_STATUS|<br />Rclone 联动模式:<br />[copy_remote_first] 下载完成后复制到${DRIVENAME}:${DRIVE_DIR}, BT任务在进入做种前触发上传</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "move_remote" ]; then
    sed -i "s|MODE_STATUS|<br />Rclone 联动模式:<br />[move_remote] 下载及做种完成后移动到本地finished目录, 然后移动到${DRIVENAME}:${DRIVE_DIR}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${POST_MODE}" = "move_remote_only" ]; then
    sed -i "s|MODE_STATUS|<br />Rclone 联动模式:<br />[move_remote_only] 下载及做种完成后移动到${DRIVENAME}:${DRIVE_DIR}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
fi
