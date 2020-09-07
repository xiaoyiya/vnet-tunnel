#!/bin/bash
#安装unzip和二进制文件
VnetTunnel_install() {
    yum -y install zip unzip
	apt install -y zip unzip
	cd /usr/local
    mkdir vnet
    cd vnet
	wget -N --no-check-certificate "https://www.yunyiya.com/download/linux/tunnel.zip"
	unzip tunnel.zip 
    rm -f /usr/local/vnet/tunnel.zip
}
#客户端安装
client_install() {
	if [ "`ss -lnp |grep -w :8080`" ]; then
		echo -e "\033[31m8080端口被占用，执行ss -lnp |grep -w :8080查看具体进程 \033[0m"
		echo -e "\033[31m释放端口后可重新执行\033[0m"
		exit 0
	fi
	VnetTunnel_install
    rm -f /usr/local/vnet/server
    echo '
#!/bin/bash
sleep 0.5
cd /usr/local/vnet
./client' >/usr/local/vnet/client.sh  
    echo '
#!/bin/bash
sleep 1.5
#在下方编写规则
' >/usr/local/vnet/client.conf
    chmod +x client client.sh client.conf
    #客户端
    echo '
[Unit]
Description=VnetClient.Service
After=rc-local.service
[Service]
Type=simple
ExecStart=/usr/local/vnet/client.sh
ExecStartPost=/usr/local/vnet/client.conf
Restart=always
LimitNOFILE=512000
LimitNPROC=512000
[Install]
WantedBy=multi-user.target' >/usr/lib/systemd/system/vnetc.service
	systemctl start vnetc
	systemctl enable vnetc
	systemctl status vnetc
	echo -e "\033[42;37mvnet客户端安装完成\033[0m" 
	echo -e "\033[42;37m输入“ systemctl start|stop|restart|status vnetc” 来查看当前运行状态\033[0m" 
}

#服务端安装
server_install() {
	if [ "`ss -lnp |grep -w :8081`" ]; then
		echo -e "\033[31m8081端口被占用，执行ss -lnp |grep -w :8081查看具体进程 \033[0m"
		echo -e "\033[31m释放端口后可重新执行\033[0m"
		exit 0
	fi
	VnetTunnel_install
    rm -f /usr/local/vnet/client
    echo '
#!/bin/bash
sleep 0.5
cd /usr/local/vnet
./server' >/usr/local/vnet/server.sh  
    echo '
#!/bin/bash
sleep 1.5
#在下方编写规则
' >/usr/local/vnet/server.conf
    chmod +x server server.sh server.conf
	echo '
[Unit]
Description=VnetServer.Service
After=rc-local.service
[Service]
Type=simple
ExecStart=/usr/local/vnet/server
ExecStartPost=/usr/local/vnet/server.conf
Restart=always
LimitNOFILE=512000
LimitNPROC=512000
[Install]
WantedBy=multi-user.target' >/usr/lib/systemd/system/vnets.service
	systemctl start server
	systemctl enable server
	systemctl status server
	echo -e "\033[42;37mvnet服务端安装完成\033[0m" 
	echo -e "\033[42;37m输入“ systemctl start|stop|restart|status server ”来查看当前运行状态\033[0m" 
}

echo "
##########################################
#        VNET管理脚本-systemd启动        #
#                                        #
#适配CentOS7+ Debian8+ Ubuntu16+         #
#                                        #
##########################################

1：安装VNet客户端(额外占用8080端口)                       
2：安装VNET服务端(额外占用8081端口)                         

"
read -p "请输入你的选择 1|2|3|4: " select
case $select in
1)
client_install
;;
2)
server_install
;;
*)
echo -e "\033[31m别瞎几把乱写\033[0m"
;;
esac




