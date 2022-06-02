**Unmaintained repo | 停止维护**  

**新项目 | Checkout [Leech-AIO-APP-EX](https://github.com/wy580477/Leech-AIO-APP-EX)**


[Click here for English version](https://github.com/wy580477/Aria2-AIO-Container/blob/master/README_en.md)

## 鸣谢

- [alexta69/metube](https://github.com/alexta69/metube) 简洁好用的yt-dlp前端。
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  依靠来自P3TERX的Aria2脚本，实现了Aria2下载完成自动触发Rclone上传。
- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  启发了本项目的总体思路。
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  使用yaml配置文件的静态导航页，便于自定义。
- [mayswind/AriaNg](https://github.com/mayswind/AriaNg) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [aria2/aria2](https://github.com/aria2/aria2) | [rclone/rclone](https://github.com/rclone/rclone) | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)

## 概述

本容器集成了yt-dlp Web前端metube、Aria2+Rclone+WebUI、Rclone联动自动上传功能、可自定义的导航页、Filebrowser轻量网盘。  

[无yt-dlp Web前端metube精简版本传送门](https://github.com/wy580477/Aria2-AIO-Container/tree/lite)  
保留了yt-dlp和其自动上传rclone脚本，闲置时内存占用仅40MB，更适合低配置host。

[Aria2独立容器精简版本传送门](https://github.com/wy580477/Aria2-Container-for-Rclone)

[Heroku版本传送门](https://github.com/wy580477/Heroku-AIO-APP-EX)

![image](https://user-images.githubusercontent.com/98247050/165260584-764dbf11-55e7-44c1-a303-bf60aff62b6b.png)

 1. 开箱即用，只需要准备rclone.conf配置文件, 容器一切配置都预备齐全。
 2. AMD64/Arm64/Armv7多架构支持。
 3. 由caddy反代所有web服务和远程控制路径，均有密码保护，可自定义基础URL防爆破，并可使用caddy自动申请证书开启https。
 4. 可自定义内容导航页，显示当前容器运行信息。
 5. Aria2/yt-dlp和Rclone多种联动模式，复制/移动。有BT下载完成做种前立即开始上传功能，适合有长时间做种需求的用户。
 6. 独立的Rclone容器以daemon方式运行，方便实时在WebUI上监测传输情况，可在docker-compose文件中自定义运行参数。
 7. Aria2和Rclone可以连接其它host上运行的AriaNg/RcloneNg等Web面板，方便集中管理。
 8. 基于 [runit](http://smarden.org/runit/index.html) 的进程管理，每个进程可以独立启停，互不影响。
 9. 所有配置集中于config数据卷，方便迁移。
 10. 支持PUID/GUID方式以非root用户运行容器内进程。

## 快速部署

 1. 建议使用docker-compose方式部署，方便修改变量配置。
 2. 下载[docker-compose文件](https://raw.githubusercontent.com/wy580477/Aria2-AIO-Container/master/docker-compose.yml)
 3. 按说明设置好变量，用如下命令运行容器。

```
docker-compose up -d
```

 4. 按ip地址或域名+基础URL就可打开导航页，随后打开AriaNg，将变量中的密码填入AriaNg设置中的RPC密钥即可连接Aria2。
 5. 打开Filebrowser页面，将事先准备好的rclone.conf配置文件上传到config目录下，运行如下命令重启容器即可让Aria2—Rclone联动功能生效。

```
docker restart allinone
```

### 更多用法和注意事项  

 1. 命令行调用yt-dlp方法：

```
docker exec allinone yt-dlp
# 可以使用alias设置别名方便使用：  
alias dlpr="docker exec allinone yt-dlp --exec ytdlptorclone.sh -P /mnt/data/videos"
# 下载到/mnt/data/videos目录并与rclone联动，受POST_MODE变量控制。注意要用容器内部路径，不是主机路径。
dlpr https://www.youtube.com/watch?v=rbDzVzBsbGM
```

 2. 考虑安全原因Filebrowser初始用户无管理员权限，如需要管理员权限，执行下列命令：

```
docker exec -it allinone sh
# 进入容器shell
sv stop filebrowser
# 停止filebrowser服务
filebrowser -d /mnt/config/filebrowser.db users add 用户名 密码 --perm.admin
# 新建管理员用户。也可以使用users update 用户名 --perm.admin命令赋予现有用户管理员权限。
sv start filebrowser
# 启动filebrowser服务
```

 3. 删除config目录下filebrowser.db文件可重置filebrowser所有设置。
 4. 无法通过Rclone Web UI远程设置需要网页认证的远程存储配置，建议在本地桌面系统上运行rclone config使用命令行配置或者rclone rcd使用Web UI网页配置。
 5. caddy如果频繁申请证书会被限制导致启动失败，所以如果使用自动https功能，config目录下caddy目录不要随意删除/移动。
 6. config/aria2目录下为Aria2相关配置文件。script.conf为Aria2自动化配置文件，可以更改文件自动清理设置和指定Rclone上传目录。
    tracker.sh为自动更新tracker脚本，每24小时自动执行，注意会覆盖原tracker设置。如需要关闭，改名或删除tracker.sh即可。
 7. config/homer_conf目录下为导航页配置文件和图标资源，配置文件详解见：<https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md>  
    添加到此目录下的图标文件，要在配置文件中以./assets/tools/example.png这样的路径调用。
