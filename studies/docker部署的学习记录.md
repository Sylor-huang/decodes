#### 1. 新建 puma 的日志、PID、和 Sockets 文件夹。
```
mkdir -p shared/log shared/pids shared/sockets
```

#### 1.1 docker查看所有的 images 

```
docker images
```

#### 1.2 docker启动添加多个端口


```
docker run -d -it -p 800:80 -p 3000:30 nginx 
```

#### 2. ubuntu/cenots 环境下docker的安装包（deb)和依赖包

```
#ubuntu环境
apt-get install --download-only docker

#centos环境
1. yum install yum-plugin-downloadonly
2.yum install --downloadonly --downloaddir=rpm包下载的目录 安装的组件名
```

#### 3. 安装指定版本rails

```
gem install rails -v=5.2.4
```
#### 4. 本地的docker环境

```
ssh root@127.0.0.1 -p 10022
```
#### 5. docker启动镜像

```
docker run -itd -p 10022:22 image-id
  # 将本机10022端口，映射到容器的22端口。
  
  #进入容器
docker exec -it 7c07ba426a27 /bin/bash
#给root设置一个密码 123456
passwd root
#修改配置文件
vim /etc/ssh/sshd_config
#注释第一行，添加第二行
# PermitRootLogin prohibit-password. 
PermitRootLogin yes

#保存退出后，重启ssh服务
/etc/init.d/ssh restart

#本机ssh连接容器
ssh root@127.0.0.1 -p 10022
```

#### 6. 镜像里的Ubuntu18.04 安装rvm后需要

```
source /usr/local/rvm/scripts/rvm
```

#### 7. 创建后台运行的容器

```
docker run -d -i -t image-id /bin/bash
```

#### 8. docker 创建端口的容器

```
docker run -itd --name=marine4 -p801:80 marine:latest /bin/bash
```

#### 9. container 中启动nginx失败

```
# 在/etc/nginx/nginx.conf中删除了以下
location = /50x.html {
            root   html;
        }
```

#### 10.docker 的自动启动

```
# 如何保证Docker容器在系统重启时，可以自动运行呢？不需要复杂的脚本。只需要增加 --restart=always
#1.新建容器时指定
docker run --restart=always

#2. 对已经创建的容器可以使用如下更新命令
docker update --restart=always 容器名称1 容器名称2
```
#### 11.Docker 给运行中的容器设置端口映射的方法


```
# 下面开启一个 nginx 服务，将本机 8080 端口映射到容器的 80 端口：
docker run -d -p 8080:80 nginx

#上面将本地主机的 8080 端口被映射到了容器的 80 端口，这时我们通过本机浏览器访问 http://localhost:8080 就会出现 nginx 欢迎页面。
```

#### 12. 查看端口映射

```
#使用 docker port 命令来查看当前映射的端口配置，也可以查看到绑定的地址。命令格式如下：
docker port CONTAINER [PRIVATE_PORT[/PROTO]]

#容器有自己的内部网络和 IP 地址，可以使用 docker inspect + 容器ID 获取容器的具体信息。
docker inspect + 容器ID  

#DOCKER 给运行中的容器添加映射端口

#1. 获得容器ip

docker inspect container_name | grep IPAddress #将container_name 换成实际环境中的容器名


#2.iptable转发端口
#将容器的8000端口映射到docker主机的8001端口
iptables -t nat -A DOCKER -p tcp --dport 8001 -j DNAT --to-destination 172.17.0.19:8000

#3.运行镜像并添加端口

##1.提交一个运行中的容器为镜像

docker commit containerid foo/live

##2.运行镜像并添加端口

docker run -d -p 8000:80 foo/live /bin/bash

```

#### 14. 测试nginx语法是否正确

```
nginx -t
```

#### 15. ubuntu 下mysql 的错误日志位置

```
/var/log/mysql/error.log
```

#### 16. 'Fatal error: Can't open and lock privilege tables: Table storage engine for 'user' doesn't have this'


```
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
service mysql start && \

然后exit

或者

find /var/lib/mysql -type f -exec touch {} \; && service mysql start
```


#### 17. ssh的相关操作

```
#sshd的重启
service sshd start | restrart

#查看ssh的状态
service ssh status

#ssh的重启
/etc/init.d/ssh restart

#ssh的配置文件
vim /etc/ssh/sshd_config
```


```
#1. 出现‘sshd: unrecognized service’问题

chmod -R 755 /var/run/sshd   #很多是因为sshd没有权限的问题，可根据ll查看。回去这个要修改

/etc/init.d/ssh restart

```

### 18. docker 测试

```
docker -v

>> Docker version 1.3.2, build 39fa2fa/1.3.2
```

### 19. 查看docker状态


```
systemctl status docker
```

### 20 启动docker

```
sudo systemctl start docker

#开机启动docker
sudo systemctl enable docker
```

### 21 停止docker容器


```
docker stop 容器id

#导出容器id
docker export 容器id/name >文件名.tar
```

### 22 导入镜像作为容器

```
#文件名 docker_udask.tar
cat docker_udask.tar | docker import - udask:v1.0

```

### 23 本地安装gem


```
先下载gem包的zip或tar文件，解压，然后使用 gem build xxx.gemrsc文件
```


#### 24 挖矿的清理程序
top

#查进程

systemctl status 进程id

#查父进程

ps auxw | grep kin

root     19650  1.0  1.3 119816 54176 ?        Sl   11:06   0:00 /var/tmp/kinsing

kill -9 19650

crontab -l  #查看定时任务

crontab -r #删除全部的定时任务

crontab -e #清除定时任务

```

```







  
