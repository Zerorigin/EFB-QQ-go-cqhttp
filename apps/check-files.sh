#!/bin/ash

# Set debug Mode
if [[ ! -z "${DEBUG}" ]]; then
    set -ex
else
    set -e +x
fi

# Check if the EFB dictionary is exist
if [ ! -d "/apps/EFB" ]; then
    cp -r /apps/EFB.Backup /apps/EFB
else

    cd /apps/EFB && mkdir -p blueset.telegram milkice.qq zerorigin.filter

    # Check if the configuration files is exists

    if [ ! -f "/apps/EFB/config.yaml" ]; then
        cp /apps/EFB.Backup/config.yaml /apps/EFB/
    fi

    if [ ! -f "/apps/EFB/blueset.telegram/config.yaml" ]; then
        cp /apps/EFB.Backup/blueset.telegram/config.yaml /apps/EFB/blueset.telegram/
    fi

    if [ ! -f "/apps/EFB/milkice.qq/config.yaml" ]; then
        cp /apps/EFB.Backup/milkice.qq/config.yaml /apps/EFB/milkice.qq/
    fi

    if [ ! -f "/apps/EFB/zerorigin.filter/config.yaml" ]; then
        cp /apps/EFB.Backup/zerorigin.filter/config.yaml /apps/EFB/zerorigin.filter/
    fi

fi


# Init go-cqhttp configs
function init_config() {
    cd /apps/go-cqhttp && cp config.default.yml conf.d/config.yml
    yq -i '.message.post-format = "array"' /apps/go-cqhttp/conf.d/config.yml
    yq -i '.message.extra-reply-data = true' /apps/go-cqhttp/conf.d/config.yml
    yq -i '. *= load("/apps/go-cqhttp.config.sub.yml")' /apps/go-cqhttp/conf.d/config.yml
    yq -i '.servers[0].http.middlewares.<< alias = "default"' /apps/go-cqhttp/conf.d/config.yml
}


# Check if the go-cqhttp config file exist
if [ ! -d "/apps/go-cqhttp/conf.d" ]; then
    cd /apps/go-cqhttp && mkdir -p conf.d
    init_config
elif [ -d "/apps/go-cqhttp/conf.d" ] && [ ! -f "/apps/go-cqhttp/conf.d/config.yml" ]; then
    init_config
fi

exit 0
