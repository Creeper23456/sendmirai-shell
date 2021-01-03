#!/bin/sh
#Creeper制作，我的网站：https://blog.cnklp.cn

#安装相关依赖
install(){
    apt update
    apt install curl jq -y
}

verify(){
    echo 正验证...
    verify_status=$(curl -s -d "{"sessionKey": $sessionKey,"qq": $qq}" $http_addr/verify | jq .code)
    if [ "$verify_status" == "0" ]; then
        echo 验证成功！
        echo 正在发送消息...
    else
        echo 验证失败，请检查配置。
        exit
    fi
}

#登录函数，yyds
login(){
    echo 登录中...
    response_auth=$(curl -s -d "{"authKey": $authKey}" $http_addr/auth) && sessionKey=$(echo $response_auth | jq .session) && login_status=$(echo $response_auth | jq .code)
    if [ "$login_status" == "0" ]; then
        echo 登录成功！
        verify
    else
        echo 登录失败，请检查登录信息是否正确，Mirai及Http-api是否正在运行。
        exit
    fi
}

sendMessage(){
    login
    #调试项目
    #echo key:$sessionKey arg:$arg2 type:$messType typeArg:$messTypeArg arg4:$arg4 httpaddr:$http_addr$messUrlArg
    sendMessage_status=$(curl -s -d "{"sessionKey": $sessionKey,"target": $arg2,"messageChain":[{"type": "$messType","$messTypeArg": "$arg4"}]}" $http_addr$messUrlArg | jq .code)
    if [ "$sendMessage_status" == "400" ]; then
        echo 错误：请不要输入空消息以及空联系人，谢谢！
    else
        echo 成功！
    fi
}

#读取用户发送的参数
read_args(){
    if [ "$arg1" == "-f" ]; then
        messUrlArg=sendFriendMessage
        if [ "$arg3" == "-t" ]; then
            messType=Plain
            messTypeArg=text
            sendMessage
        elif [ "$arg3" == "-p" ]; then
            messType=Image
            messTypeArg=url
            sendMessage
        else
            echo 错误：请输入正确的参数。
            exit
        fi
    elif [ "$arg1" == "-g" ]; then
        messUrlArg=sendGroupMessage
        if [ "$arg3" == "-t" ]; then
            messType=Plain
            messTypeArg=text
            sendMessage
        elif [ "$arg3" == "-p" ]; then
            messType=Image
            messTypeArg=url
            sendMessage
        else
            echo 错误：请输入正确的参数。
            exit
        fi
    else
        echo 错误：请输入正确的参数。
        exit
    fi
}

help_echo(){
    #帮助信息
    echo 脚本基于Mirai-http-api编写。PigeonClub鸽社技术组，版权所有。登录前请修改根目录下的config.json完成一些必要的设定。
    echo 用法：
    echo $0 -f [QQ号] [内容格式] [内容/图片URL] 向机器人的好友发送文本/图片消息，内容请务必使用半角符号引起，图片消息为URL格式。 
    echo $0 -g [群号] [内容格式] [内容/图片URL] 向机器人已加入的群发送文本/图片消息，内容请务必使用半角符号引起，图片消息为URL格式。
    echo 支持的内容格式：-t：文字，-p：图片。
    echo $0 install 安装必要的依赖，请务必在使用前先运行安装命令。
}

#fucation for start
script_abs=$(readlink -f "$0")
script_dir=$(dirname $script_abs)
cd $script_dir
arg1=$1
arg2=$2
arg3=$3
arg4=$4
arg5=$5
http_addr=http://127.0.0.1:8080/
qq=$(cat config.json | jq .qq)
authKey=$(cat config.json | jq .authKey)
if [ "$1" == "install" ]; then
    install
elif [ "$1" == "help" ]; then
    help_echo
elif [ "$1" == "test" ]; then
    fucation_test
elif [ "$1" == "-m" ]; then
    message_friend
elif [ "$arg1" == "-f" ]||[ "$arg1" == "-g" ]; then
    read_args
else
    echo -e "\033[31m错误：缺少参数或参数错误\033[0m"
    help_echo
fi