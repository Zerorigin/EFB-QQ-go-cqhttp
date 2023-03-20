FROM python:3-alpine
LABEL blogger="清雨@https://blog.gazer.win/"
LABEL maintainer="Zerorigin <871670172@qq.com>"

# Init system envs
ENV LANG C.UTF-8
ENV TZ "Asia/Shanghai"

# Change to work directory and expose the ports
WORKDIR /apps
EXPOSE 5700 8000

# Set system environments
RUN set -ex && sed -i "s/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g" /etc/apk/repositories
RUN set -ex \
    && apk add --no-cache \
    ca-certificates curl jq tzdata s6-overlay wget yq`# for System Requirements Envs` \
    ffmpeg `# for cqhttp and EFB` \
    jpeg libmagic libwebp libwebp-static openjpeg zlib `# for EFB`

# Set the Timezone
RUN set -ex \
    && ln -sf $(echo /usr/share/zoneinfo/${TZ}) /etc/localtime \
    && echo ${TZ} > /etc/timezone

# Download and Install go-cqhttp
RUN set -ex \
    && mkdir -p /apps/go-cqhttp && cd go-cqhttp \
    && curl --http2 --tlsv1.3 -Ls https://github.com/Mrs4s/go-cqhttp/releases/latest/download/go-cqhttp_linux_amd64.tar.gz -o ./go-cqhttp.tgz \
    && tar axvf ./go-cqhttp.tgz && rm -f ./go-cqhttp.tgz \
    && chmod +x ./go-cqhttp && echo | ./go-cqhttp \
    && mv ./config.yml ./config.default.yml \
    && ln -sf /apps/go-cqhttp/go-cqhttp /usr/local/bin/go-cqhttp \
    && chmod +x /usr/local/bin/go-cqhttp

# Install EFB & EFB Modules
RUN set -ex \
    && apk add --no-cache --virtual .build-deps build-base cmake git jpeg-dev libffi-dev libwebp-dev openjpeg-dev openssl-dev zlib-dev \
    && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && /usr/local/bin/python -m pip install --upgrade pip && pip3 install wheel \
    && pip3 install webp Pillow==9.0.1 python-telegram-bot[socks] `# for EFB` \
    && pip3 install ehforwarderbot efb-qq-slave \
    && pip3 install git+https://github.com/ehForwarderBot/efb-qq-plugin-go-cqhttp \
    && pip3 install git+https://github.com/zerorigin/efb-filter-middleware \
    && pip3 install efb-telegram-master \
    && rm -rf ~/.cache/pip/* && apk del .build-deps

# Copy config files and s6-overlay settings
COPY ./apps /apps
COPY rootfs /
RUN set -ex && chmod -R +x /etc/s6-overlay/s6-rc.d

# Health Check
HEALTHCHECK --start-period=45s --interval=10s --timeout=3s \
    CMD set -ex && chmod +x /apps/healthcheck.sh && ash /apps/healthcheck.sh

ENTRYPOINT ["/init"]
