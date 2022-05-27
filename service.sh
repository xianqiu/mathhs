# tornado
service_name="mathhs"

function check_status {
    pid_list=`ps -ef | grep "${1}" | grep -v "grep" | awk '{print \$2}'`
    if [ "${pid_list}" ]
    then
        echo "pids:"
        echo "${pid_list}"
        echo ">> ${1} started."
    else
        echo ">> ${1} fail to start."
    fi
}

# 启动 
function start_service {
    # react
    cd ${service_name}
    start="nohup serve -s web -l 80 > react.log 2>&1 &"
    echo ">> ${start}"
    nohup serve -s web -l 80 > react.log 2>&1 &
    check_status "serve -s web"
    
    # tornado
    start="nohup python3 run.py > output.log 2>&1 &"
    echo ">> ${start}"
    nohup python3 run.py > output.log 2>&1 &
    check_status "run.py"
    cd ..
}

function kill_process {
    pid_list=`ps -ef | grep "${1}" | grep -v "grep" | awk '{print \$2}'`
    for pid in $pid_list
    do
        kill -9 ${pid} 
        echo "killed ${pid}."  
    done
}

# 停止
function stop_service {
    echo ">> Stopping react service ..."
    kill_process "run.py"
    echo ">> Done."
    echo ">> Stopping tornado service ..."
    kill_process "serve -s web"
    echo ">> Done."
}

# 重启
function restart_service {
    stop_service
    start_service
}


function menu {
    echo
    echo "[菜单]"
    echo "1. 启动服务(React+Tornado)"
    echo "2. 停止服务(React+Tornado)" 
    echo "3. 重启服务(React+Tornado)" 
    echo "0. 退出\n"
    #-en 选项会去掉末尾的换行符，这让菜单看起来更专业一些
    echo "请选择(按'回车'确认):" 
    #read 命令读取用户输入
    read -n 2 option
}

while [ 1 ]
do 
    menu
    case ${option} in
    0)
        break;;
    1)
        start_service 
        ;;
    2)
        stop_service 
        ;;
    3)
        echo "重启服务(React+Tornado)" 
        ;;
    *)
        echo $option
        echo "输入错误" 
        ;;
    esac

    echo "\n \ 按任意键继续... \ "
    read -n 1 line
done


