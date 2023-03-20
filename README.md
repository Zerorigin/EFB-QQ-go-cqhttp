# EFB-QQ-go-cqhttp
ehForwarderBot with Telegram Bot to receive QQ messages


一、食用指南


0. 准备工作
```
# 基础的 Docker 组件安装及使用方法这边不再累赘(容器镜像亦可用于 Podman 等)
# 拉取 Docker Container Image 镜像
docker pull orcinusorcas/efb-qq-go-cqhttp:latest
```


注意事项：

0、建议把单独把配置文件目录映射出来，保鲜以便下次继续食用

1、初次运行时必须使用环境变量配置，否则无法正常运行

2、环境变量的配置项具有高优先级，会覆盖配置文件里相应的配置项

3、未适配环境变量的配置项，请手动在配置文件里修改


以下几项环境变量是必须在环境变量做配置才能正常启用相关配置的：
```
CFG_TGBOT_PROXY
CFG_MODS_FILTER
```


1. 方式一：`docker run` 管理方案
```shell
# 初次运行时，使用此方法方便生成并调试配置文件
docker run -it --rm --name="efbqq" \
    --network=host --restart=no \
    -e CFG_TGBOT_ADMIN=10000 \
    -e CFG_TGBOT_PROXY=http://XXX.XXX.XXX.XXX:端口号/ \
    -e CFG_TGBOT_TOKEN=012345:ABCDEFG \
    -e CFG_CQHTTP_QQ=10001 \
    -v /宿主/EFBQQ/data.d/ehforwarderbot/:/apps/EFB/ \
    -v /宿主/EFBQQ/data.d/go-cphttp/:/apps/go-cqhttp/conf.d/ \
    orcinusorcas/efb-qq-go-cqhttp:latest

# 登录 QQ 后使用另一个 shell 窗口使用此命令 `docker stop efbqq` 停止现有容器服务
# 配置文件生成后，可使用此方式以继续使用现有的配置档案
docker run --name="efbqq" \
    --network=host --restart=always \
    -e CFG_TGBOT_ADMIN=10000 \
    -e CFG_TGBOT_PROXY=http://XXX.XXX.XXX.XXX:端口号/ \
    -e CFG_TGBOT_TOKEN=012345:ABCDEFG \
    -e CFG_CQHTTP_QQ=10001 \
    -v /宿主/EFBQQ/data.d/ehforwarderbot/:/apps/EFB/ \
    -v /宿主/EFBQQ/data.d/go-cphttp/:/apps/go-cqhttp/conf.d/ \
    -d orcinusorcas/efb-qq-go-cqhttp:latest

# 此后每次修改配置文件，可使用 `docker restart efbqq` 来重启容器服务

```



2. `docker-compose` - 推荐


1、克隆项目文件到本地主机上
```shell
git clone --depth 1 https://github.com/orcinusorcas/EFB-QQ-go-cqhttp.git
```

2、根据需要修改项目根目录下的 `.env` 文件

3、使用 `docker-compose up` 启动容器服务

4、初次生成并调试完配置文件，可使用组合键 `Ctrl+C` 来停止当前容器，此后使用
`docker-compose up -d` 在后台启动容器服务即可

5、并且每次修改配置文件，一样可使用 `docker restart efbqq` 来重启容器服务



二、资料参考(同时感谢开源者的无私奉献)

https://github.com/ehForwarderBot/ehForwarderBot

https://github.com/ehforwarderbot/efb-telegram-master


https://github.com/ehForwarderBot/efb-qq-plugin-go-cqhttp

https://github.com/ehForwarderBot/efb-qq-slave

https://github.com/zerorigin/efb-filter-middleware


https://github.com/just-containers/s6-overlay

https://github.com/Mrs4s/go-cqhttp
