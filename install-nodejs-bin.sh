#!/usr/bin/env bash

# 工作目录
WORKING_DIR=/tmp

# 软件名称
SOFTWARE_NAME=node

# 软件版本
SOFTWARE_VERSION=8.9.1

# 二进制包名称 node-v8.9.1-linux-x64.tar.gz
ARCHIVE_NAME="${SOFTWARE_NAME}-v${SOFTWARE_VERSION}-linux-x64.tar.gz"

# 二进制包下载地址 https://nodejs.org/dist/v8.9.1/node-v8.9.1-linux-x64.tar.gz
ARCHIVE_DOWNLOAD_URL="https://nodejs.org/dist/v${SOFTWARE_VERSION}/${ARCHIVE_NAME}"

# 二进制包解压后目录名称 node-v8.9.1-linux-x64
SOURCE_DIR_NAME="${SOFTWARE_NAME}-v${SOFTWARE_VERSION}-linux-x64"

# 二进制包保存路径
ARCHIVE_SAVE_PATH="${WORKING_DIR}/${ARCHIVE_NAME}"

# 二进制文件所在目录
SOURCE_DIR="${WORKING_DIR}/${SOURCE_DIR_NAME}"

# 安装目录的根目录
INSTALL_ROOT="/usr/local/${SOFTWARE_NAME}"

# 安装目录
INSTALL_DIR="/${INSTALL_ROOT}/${SOFTWARE_NAME}-${SOFTWARE_VERSION}"

# 当前使用版本的符号链接
CURRENT_VERSION="${INSTALL_ROOT}/current"

# 二进制文件路径的配置文件
SOFTWARE_PROFILE="/etc/profile.d/${SOFTWARE_NAME}.sh"

# 配置二进制文件路径
function config_binary_path() {
    echo "${INSTALL_ROOT}/${SOFTWARE_NAME}/bin" > $SOFTWARE_PROFILE
}

# 进入工作目录
cd $WORKING_DIR

# 下载二进制包
if [ ! -e "$ARCHIVE_SAVE_PATH" ]; then
    wget -O $ARCHIVE_SAVE_PATH $ARCHIVE_DOWNLOAD_URL
fi

# 下载失败，不再继续。
if [ ! -e "$ARCHIVE_SAVE_PATH" ]; then
    echo "[ERROR] Download ${ARCHIVE_NAME} failed."
    exit 1
fi

# 备份旧的二进制文件目录
if [ -d "$SOURCE_DIR" ]; then
    mv $SOURCE_DIR "${SOURCE_DIR}-$(date +%Y%m%d%H%M%S)"
fi

# 备份旧的安装目录
if [ -d "$INSTALL_DIR" ]; then
    mv $INSTALL_DIR "${INSTALL_DIR}-$(date +%Y%m%d%H%M%S)"
fi

# 解压二进制包
tar zxvf $ARCHIVE_SAVE_PATH

# 移动到 /usr/local/node
mv $SOURCE_DIR $INSTALL_DIR

# 配置二进制文件路径
config_binary_path

echo "################################################################################"
echo "# Open a new terminal or enter: source ${SOFTWARE_PROFILE}"
echo "################################################################################"
