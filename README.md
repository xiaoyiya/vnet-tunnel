# vnet-tunnel

博客地址：www.yunyiya.com

脚本地址（CentOS 7 x64）

yum -y install wget;wget -N --no-check-certificate "https://raw.githubusercontent.com/xiaoyiya/vnet-tunnel/master/vnet.sh";chmod +x vnet.sh;./vnet.sh

已知问题：无法开机自启，重启后丢失数据

解决方案：用systemd启动，用配置文件代替网页输入（尚未解决）
