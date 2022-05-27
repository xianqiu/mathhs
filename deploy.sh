#!/bin/bash

#-------#
# 配置项 #
#-------#

# 前端仓库地址
repo_add_front="https://github.com/xianqiu/math-homework-react"
# 服务端仓库地址
repo_add_back="https://github.com/xianqiu/mathhs"

# react
react_app_name="math-homework-react"
react_packages=("antd" "axios")
# python service
# math homework serveice
service_name="mathhs"

#--------------#
# 创建React环境 #
#--------------#

if [ -d "${react_app_name}" ] 
then
    echo "The environment is OK. Go to deploy process."
    goto process_deploy
fi

# 创建 
npx create-react-app ${react_app_name}
cd ${react_app_name}
# 添加依赖 
echo "Adding packages >>>"
for p in ${react_packages[*]}
do
    npm add ${p}
    echo "\t [${p}] added."
done
cd ..

#--------------#
# 获取前后端代码 #
#--------------#

# 前端代码
cd ${react_app_name}
# 初始化本地仓库
git init
# 添加远程仓库
git remote add origin ${repo_add_front}
# 将更新取回本地
git fetch --all
# 用远程服务器的origin/main 替换本地、暂存区、版本库
git reset --hard origin/main
# 同步代码 
git pull origin main
cd ..

# 服务端代码
git clone -b main ${repo_add_back}


#---------#
# 服务部署 #
#---------#
process_deploy:

# 编译前端
cd ${react_app_name}
# 注意：提前安装静态页面服务器
# sudo npm install -g serve
npm run build
cd ..

# 把前端页面放到服务端的web文件夹下
cp -avx ${react_app_name}/build/* ${service_name}/web

