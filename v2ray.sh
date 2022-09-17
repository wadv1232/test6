#!/bin/sh

# Set ARG
PLATFORM=$1

if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download files
V2RAY_FILE="v2ray-linux-${ARCH}.zip"
echo "Downloading binary file: ${V2RAY_FILE}"

wget -O ${PWD}/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.2/${V2RAY_FILE} > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${V2RAY_FILE}" && exit 1
fi
echo "Download binary file: ${V2RAY_FILE} completed"

# Prepare
echo "Prepare to use"
unzip v2ray.zip && chmod +x v2ray v2ctl
mv v2ray v2ctl /usr/bin/
mv geosite.dat geoip.dat /usr/local/share/v2ray/
mv config.json /etc/v2ray/config.json

# Clean
rm -rf ${PWD}/*


if [ ! -f UUID ]; then
	cat /proc/sys/kernel/random/uuid > UUID
fi

UUID=$(cat UUID)

# Set config.json
sed -i "s/PORT/$PORT/g" /etc/v2ray/config.json
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json

echo starting v2ray platform
echo starting with UUID:$UUID
echo listening at 0.0.0.0:$PORT
echo "Done"
exec "$@"
