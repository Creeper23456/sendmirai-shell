# SendMirai-shell
## 通过Mirai http-api实现的消息发送及自动报警Shell脚本

### 用法：
clone本仓库后有两个文件：

mirai.sh，直接在shell内运行，通过命令参数发送消息，运行./mirai.sh -h可以获得帮助消息。

sendmirai为SSH报警用静默执行文件。对于配置的修改，Http_addr的修改需同步进行。

如果你的http api地址需要修改，请修改mirai.sh或sendmirai脚本底下的http_addr参数。

使用前请务必修改config.json并填入你发送消息的QQ号以及mirai http-api的key。

### To-do list:

- [x] 初步实现群消息发送

- [ ] 完善前置安装程序

- [ ] 完善文档

- [ ] 完成对图片发送的支持

- [ ] 完善配置文件的读取，从jq改为shell变量引入

- [ ] crontab下对服务器性能持续监测并在服务器超载时报警

- [ ] SSH暴力破解报警

### 不久后会支持的特色：

- [ ] 消息定时接收、存档

### 感谢：

机器人框架来自：[mirai](https://github.com/mamoe/mirai-console)

测试环境来自：[PigeonClub技术组](https://club.cnklp.cn)
