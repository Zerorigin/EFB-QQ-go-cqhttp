#!/bin/ash

# Set debug Mode
if [[ ! -z "${DEBUG}" ]]; then
    set -ex
else
    set -e +x
fi

#############################
#
# blueset.telegram settings
#
#############################

# Set Telegram Bot Token
if [[ ! -z "${CFG_TGBOT_TOKEN}" ]]; then
    yq -i '.token = strenv(CFG_TGBOT_TOKEN)' /apps/EFB/blueset.telegram/config.yaml
fi

# Set Telegram Bot Admin UID
if [[ ! -z "${CFG_TGBOT_ADMIN}" ]]; then
    yq -i '.admins = [env(CFG_TGBOT_ADMIN)]' /apps/EFB/blueset.telegram/config.yaml
fi

# Set Telegram Proxy Url
if [[ ! -z "${CFG_TGBOT_PROXY}" ]]; then
    yq -i '.request_kwargs.proxy_url = strenv(CFG_TGBOT_PROXY)' /apps/EFB/blueset.telegram/config.yaml
else
    yq -i 'del(.request_kwargs)' /apps/EFB/blueset.telegram/config.yaml
fi



#############################
#
# milkice.qq settings
#
#############################

if [[ ! -z "${CFG_MODS_FILTER}" ]]; then

    if [ $(yq '.middlewares.[] | select(. == "xzsk2.filter")' /apps/EFB/config.yaml | wc -l) -eq 0 ]; then
        yq -i '.middlewares += ["xzsk2.filter"]' /apps/EFB/config.yaml
    fi

    if [ ! -f "/apps/EFB/xzsk2.filter/config.yaml" ]; then
        cd /apps/EFB/ && mkdir -p xzsk2.filter
        cp /apps/EFB.Backup/xzsk2.filter/config.yaml /apps/EFB/xzsk2.filter/
    fi

elif [ $(yq '.middlewares.[] | select(. == "xzsk2.filter")' /apps/EFB/config.yaml | wc -l) -ne 0 ]; then
    yq -i 'del(.middlewares.[] | select(. == "xzsk2.filter"))' /apps/EFB/config.yaml
fi



#############################
#
# go-cqhttp settings
#
#############################

if [[ ! -z "${CFG_CQHTTP_QQ}" ]]; then
    yq -i '.account.uin = env(CFG_CQHTTP_QQ)' /apps/go-cqhttp/conf.d/config.yml
fi

exit 0
