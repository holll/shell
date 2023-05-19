#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

DIRECTORY=$1 # 脚本工作目录，记得修改为你要处理的文件/文件夹的上层目录绝对路径
INFO="[信息]" && ERROR="[错误]" && TIP="[注意]"
IFS=$'\n' # 指定循环分割符为换行符，避免被 文件/文件夹名称 中的空格影响

# 压缩文件夹
_ZIP() {
	# 获取所有文件夹列表，并循环将文件夹名赋予给 FOLDER 变量
	for FOLDER in $(ls -F | grep '/$' | sed 's/\///g')
    do
		ZIP_NAME="${FOLDER}.zip"
		[[ -e "${ZIP_NAME}" ]] && _RANDOM && ZIP_NAME="${FOLDER}_${RAND}.zip" # 如果存在同名压缩包文件，则在压缩包名中添加随机字符
    	zip -qr9 "${ZIP_NAME}" "${FOLDER}/" # 压缩文件夹，q=安静模式，0=仅打包（压缩程度为：0-9）
		if [[ ${?} == 0 ]]; then
			echo "${INFO} 压缩成功！[${ZIP_NAME}]"
			rm -rf "${FOLDER}" # 压缩后删除文件夹
			# mv ${ZIP_NAME} '/var/ftp/pub/'${ZIP_NAME}
		else
			echo "${ERROR} 压缩失败！[${ZIP_NAME}]"
		fi
	done
}

# 生成随机数，用于压缩时，如果存在同名压缩包文件，则在压缩包名中添加随机字符
_RANDOM() {
	RAND=$(date +%s%N | md5sum | head -c 4)
}

# 进入工作目录
[[ ! -d "${DIRECTORY}" ]] && echo "${ERROR} 工作目录不存在！" && exit 1
cd "${DIRECTORY}"
_ZIP
