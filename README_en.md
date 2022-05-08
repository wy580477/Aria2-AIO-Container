## Acknowledgments

- [alexta69/metube](https://github.com/alexta69/metube)  Simple and easy-to-use yt-dlp frontend.
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  Rely on the Aria2 script from P3TERX to automatically trigger the Rclone upload after the Aria2 downloads completed.
- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  Inspiration for this project.
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  A very simple static homepage for your server.
- [mayswind/AriaNg](https://github.com/mayswind/AriaNg) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [aria2/aria2](https://github.com/aria2/aria2) | [rclone/rclone](https://github.com/rclone/rclone) | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)

[Overview](#Overview)

[Deployment](#Deployment)

[First run](#first)  

[More usages and precautions](#more)  

## <a id="Overview"></a>Overview

This project integrates metube yt-dlp web frontend, Aria2 + WebUI, Rclone + WebUI with auto-upload function, customizable portal page, Filebrowser.  

[Lite version(without yt-dlp web frontend metube)](https://github.com/wy580477/Aria2-AIO-Container/tree/lite)  
This version still has yt-dlp and only costs 40MB memory while idling.

[Stand alone Aria2 container with Rclone auto-upload function](https://github.com/wy580477/Aria2-Container-for-Rclone)

[Heroku version](https://github.com/wy580477/Heroku-All-In-One-APP)

![image](https://user-images.githubusercontent.com/98247050/167285865-fd8a02bc-fb45-4d8f-a363-29860032df67.png)

 1. Rclone auto-upload function only needs to prepare rclone.conf file, and all other configurations are set to go.
 2. AMD64/Arm64/Armv7 multi-architecture support.
 3. All web services and remote control paths are behind caddy reverse proxy and protected by password. You can customize base URL to hide you web services from brute force attack, and enable auto-https function from caddy.
 4. Customizable portal page.
 5. Rclone have multiple auto-upload modes, copy, move, and uploading while seeding.
 6. YT-dlp Web front-end metube also supports Rclone auto-upload after downloads completed.
 7. Rclone runs in daemon mode, easy to manually transfer files and monitor transfers in real time on WebUI.
 8. Rclone which runs in standalone container can have customized parameters in docker-compose file.
 9. You can connect to Aria2 and Rclone from other frontends such as AriaNg/RcloneNg running on other hosts.
 10. All configurations are stored in config data volume for easy migration.
 11. [runit](http://smarden.org/runit/index.html)-based process management, each service can be started and stopped independently.
 12. Support using PUID/GUID env to run processes in container under non-root users.

## <a id="Deployment"></a>Deployment

 1. Download [docker-compose file](https://raw.githubusercontent.com/wy580477/Aria2-AIO-Container/master/docker-compose_en.yml)
 2. Set envs and run container with following command:
```
docker-compose -f docker-compose_en.yml up -d
```
 3. Visit IP address/domain name + base URL to open portal page, then open AriaNg and fill in RPC secret token with PASSWORD env value in AriaNg settings to connect to Aria2.
 4. Open Filerowser page and upload prepared rclone.conf file to config folder, then run following command to to enable auto-upload function.  
```
docker restart allinone
```

## <a id="more"></a>More usages and precautions

 1. How to use yt-dlp via command line：  
```
docker exec allinone yt-dlp
# Set alias：  
alias dlpr="docker exec allinone yt-dlp --exec ytdlptorclone.sh -P /mnt/data/videos"
# Download videos to /mnt/data/videos folder, then send job to Rclone according to POST_MODE env.
dlpr https://www.youtube.com/watch?v=rbDzVzBsbGM
```

 2. Considering security reasons, the initial user of Filebrowser doesn't have administrator privileges. If administrator privileges are wanted, run following commands:  

```
docker exec -it allinone sh
# enter container shell
sv stop filebrowser
# stop filebrowser service
filebrowser -d /mnt/config/filebrowser.db users add 用户名 密码 --perm.admin
# add new account with admin privileges
sv start filebrowser
# start filebrowser service
```

 3. To reset filebrowser settings, delete filebrowser.db file under config folder.
 4. You can't config Rclone remote via Rclone WebUI. It is recommended to run rclone config on local desktop OS.
 5. If you frequently apply for certificates, caddy will be throttled and cause startup failures. So if you are using auto-https function, caddy directory under config folder should not be deleted/moved frequently.
 6. Under config/aria2 folder there are Aria2 related config files. script.conf is Aria2 automation configuration file which allows you to change the automatic file cleanup settings and specify the Rclone upload directory.  
    tracker.sh automatically updates Aria2 tracker list every 24 hours. Noting that original tracker list will be overwritten. If you need to disable this fuction, rename or delete tracker.sh.
 7. Under config/homer_conf folder there are portal page config file and icon resources, for more information of config file: https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md   
After icons added to this folder, set icon path to such as ./assets/tools/example.png to use newly added icons.
