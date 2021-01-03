#!/bin/bash
shell_path=/home/ubuntu/shell/creeperpush
qq_num=2749478757
group_num=824570173
# 使用教程：
# shell_path请设置为sendmirai所在的位置。
# qq_num请设置为你想通知的QQ号。
# group_num请设置为消息广播的群号。
# 将此脚本加入/etc/profile.d文件夹中即可生效
if [ "$USER" != "root" ] ||  [ "${SSH_CLIENT%% *}" != "192.168.123.37" ];then
   messageSend=$(echo -e "警告：ssh登录成功！登入者IP地址：${SSH_CLIENT%% *}，如是陌生IP，请警惕！")
   bash $shell_path/sendmirai -f $qq_num -t $messageSend >/etc/null
   bash $shell_path/sendmirai -g $group_num -t $messageSend >/etc/null
fi