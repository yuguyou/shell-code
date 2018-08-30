#!/bin/bash
#file name: upgrade.sh
#系统升级脚本
#example:
#  weixin.6.7.2.tbz
#  $ sh upgrade.sh weix


# 程序执行异常未捕获到时终止执行
set -e

# 错误处理
function error_exit {
  echo -e "\033[31mERROR: $1 \033[0m"
  exit 1
}

# 获取与验证参数
SYS_NAME=$1
case ${SYS_NAME} in
  weix)
    echo '开始升级weix...'
    ;;
  weix)
    echo '开始升级weix...'
    ;;
  weix)
    echo '开始升级weix...'
    ;;
  *)
    error_exit '参数错误'
    error_exit '以升级weix.1.11.1.tbz为例： sh upgrade.sh weix'
    ;;
esac



############ CODE ENV ###########

OBJECT_DIR=`pwd`

DEPLOY_DIR=$OBJECT_DIR/deploy

TIME=`date "+%Y-%m-%d_%H:%M"`



##########备份当前版本###########

cd ${OBJECT_DIR}/${SYS_NAME} || error_exit "更新失败：系统${SYS_NAME}目录不存在"

# 查询带版本号行
version_line=`grep '"version": "[0-9]*\.[0-9]*\.[0-9]*"' package.json` || error_exit '未找到系统版本号，package.json文件异常'

# package.json查询到多个版本号时退出更新
version_line_count=`echo "${version_line}" | wc -l`
if [ ${version_line_count}  -ne 1 ]
then
  error_exit '未找到系统版本号，package.json文件异常'
fi

# 获取版本号
VERSION=`echo "${version_line}" | grep -o "[1-9]*\.[0-9]*\.[0-9]*"`

echo "当前版本号：${VERSION}"

cd ${OBJECT_DIR}

mkdir -p ${OBJECT_DIR}/backup/${SYS_NAME} || error_exit "mkdir -p ${OBJECT_DIR}/backup/${SYS_NAME}"

backup_dir="${OBJECT_DIR}/backup/${SYS_NAME}/${TIME}_${SYS_NAME}.${VERSION}"

cp -a ${SYS_NAME} ${backup_dir} || error_exit '备份失败'

echo "当前版本已备份到 ${backup_dir}"



##########更新文件###########

cd ${DEPLOY_DIR}

# 获取更新包
pkg_name=`ls | grep -E "${SYS_NAME}\.([0-9]+\.){3}tbz"` || error_exit '获取升级包失败，请确保升级包格式正确以及目录中存在唯一的升级包'

# 更新包检测
pkg_count=`echo "${pkg}" | wc -l`
if [ "$pkg_count" -ne 1 ]
then
  error_exit '获取升级包失败，请确保升级包格式正确以及目录中存在唯一的升级包'
fi


rm -rf ${SYS_NAME}

# 解压包
tar -xaf ${pkg_name} || error_exit "更新包(${pkg_name})解压失败"

# 更新文件
cp -r ${SYS_NAME}/. ${OBJECT_DIR}/${SYS_NAME}/ || error_exit "更新文件失败，请手工执行: cp -r ${SYS_NAME}/. ${OBJECT_DIR}/${SYS_NAME}/"

mv ${pkg_name} ${OBJECT_DIR}/backup/${SYS_NAME}/

rm -r ${SYS_NAME}

echo "新版本(${pkg_name})已经更新到 ${OBJECT_DIR}/${SYS_NAME}"



##########重起服务###########


echo "${SYS_NAME}版本升级成功"
