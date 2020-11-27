
#### 蓝湖
密码: xSnQ

#### trusit 导出zip


```
RAILS_ENV=production rake zip:pack CLASS=HomeworkCommon ID=10706
```

### 迁移后需要修改回来的内容



```
cp -r /Users/hs/forge_edu/forgeplus-react/build/* /Users/hs/forge_edu/forgeplus/public/react/build/

军科需执行：
bundle exec rails runner "SyncUserForgeTask.new.call() -e production

执行完后，forge需执行

bundle exec rake create_gitea_data:created_repo -e production

bundle exec rake create_gitea_data:created_user -e production

```
### Educoder 的gitlab
```
#educoder bggit

http://bdgit.educoder.net/users/sign_in

root 

Edu_@pd:lk3+407


# 新增gitlab用户

u = User.find_by(login: "dddd")
g = Gitlab.client
g_user = g.create_user(u.mail, u.hashed_password, name: u.show_name, username: u.login, confirm: "true")

u.gid = g_user.id
u.save
```

### forge上线


```
后端上线：
bash /home/pdl/update.sh
前端上线：
bash /home/pdl/build_update.sh

# whenever 更新
RAILS_ENV=production # 生产环境
whenever -i 更新定时任务，将schedule.rb中的任务更新到cronjob中
whenever -w  执行周期性任务
crontab -l 查看任务

```

### forge 论坛


```
跳板机:
ssh root@123.59.135.93 -p30122
@pd:lk4+407

# 先连跳板机，再连下面的

#测试版
https://testforum.trustie.net/

ssh 登录地址

ssh pdl@10.9.61.23 -p1122

pre123123

# 正式版 
https://forum.trustie.net/

ssh pdl@10.9.168.65 -p1122

pre123123
```




### testgitea2修改数据库


```
# readme 的路径
/var/lib/gitea/custom/options/readme/readme

mysql -uroot -pTrust_#%01 -h10.9.70.25

show databases;

drop database testgitea5;

create database testgitea2;

exit;

vi /etc/gitea/app.ini

#log 日志 
/var/lib/gitea/log

然后你修改一下服务器里面的数据库名

service gitea restart



#清空sidekiq队列
Sidekiq.redis { |conn| conn.flushdb }

#启动sidekiq
bundle exec sidekiq -C config/sidekiq.yml -e production -d


#启动同步

bundle exec rails runner "SyncUserForgeTask.new.call()" -e production
```


### forge

```
后端仓库：http://gitea.trustie.net/jasder/forgeplus.git
前端源代码仓库：http://gitea.trustie.net/jasder/forgeplus-react.git
前端react build仓库： http://gitea.trustie.net/jasder/build.git


https://gitea.trustie.net/
链接方式：sshpass -p @pd:lk6+407 ssh -o StrictHostKeyChecking=no -p 30122 root@10.9.117.109

forgeplus平台正式版:

https://forgeplus.trustie.net/

ssh 登录地址

sshpass -p pre123123 ssh -o StrictHostKeyChecking=no -p 1122 pdl@10.9.134.93 
数据库连接方式

mysql -uroot -pTrust_#%01 -h10.9.60.75



bundle exec sidekiq -C config/sidekiq.yml -e production -d


forge上线
跳板机:
ssh root@123.59.135.93 -p30122
@pd:lk4+407

web：
ssh -p1166 pdl@127.0.0.1
pre123123

部署脚本：
bash update.sh

testgitea默认用户
password: tr_D_00001
username: trustietest

testgitea2默认用户
 root/_Trustie_10010


forgeplus的上线版数据库链接方式:

##https://testgitea2.trustie.net的ssh

 ucloudtest.trustie.net
  
  跳板机ssh root@123.59.135.93 -p30122 密码 @pd:lk4+407
  
sshpass -p "#pd:lk3+407" ssh -o StrictHostKeyChecking=no -p 30122 root@10.9.101.74


#https://testgitea.trustie.net/ 的ssh

### sshpass登录
  sshpass -p "@pd:lk4+407" ssh -o StrictHostKeyChecking=no -p 30122 root@123.59.135.93
  
  跳板机ssh root@123.59.135.93 -p30122 密码 @pd:lk4+407

sshpass -p "#pd:lk3+407" ssh -o StrictHostKeyChecking=no -p 30122 root@10.9.69.134




https://testforgeplus.trustie.net/projects
#连接到ucloud跳板机
# ssh root@123.59.135.93 -p30122 密码 @pd:lk4+407


 sshpass -p "@pd:lk4+407" ssh -o StrictHostKeyChecking=no -p 30122 root@123.59.135.93
#连接到testforgeplus容器
ssh pdl@10.9.151.72 -p1122 密码pre123123

 sshpass -p "pre123123" ssh -o StrictHostKeyChecking=no -p 1122 pdl@10.9.151.72
#上线脚本
/home/pdl/update.sh
#重启web服务
/home/pdl/nginx/sbin/nginx -s reload #或者执行上线脚本
```
### 绿盟上线脚本

```
#http://opengcc.org/welcome/about
ssh -p1122 pdl@106.75.35.115 / gcc@pd:lk0+1
sh script/newcodeupdate_forge.sh
```


### Educoder 的pre版本


```
pre-newweb.educoder.net：
1.先通过jumpserver链接到Pre-new-web01
2.ssh 链接到容器里面
ssh pdl@127.0.0.1 -p1122 密码pre123123
3.alias查看上线命令；

pre-oldweb.educoder.net：
1.先通过jumpserver链接到Pre-pld-web01
2.ssh 链接到容器里面
ssh pdl@127.0.0.1 -p1122 密码pre123123
3.alias查看上线命令；

alias查看上线的脚本
```

### Trustie正式版


```
第一台
ssh pdl@10.9.79.106 -p1123

@pd:lk6+407
第二台
ssh pdl@10.9.79.106 -p1124

@pd:lk6+407
```


### Trustie-web测试版:

```
  ucloudtest.trustie.net
  
  跳板机ssh root@123.59.135.93 -p30122 密码 @pd:lk4+407
  
  ssh pdl@10.9.67.91 -p1122
  密码 123123
  
  sh script/newcodeupdate.sh
```
### ihub测试版的上线脚本

```
本地的局域网链接： rails s -p 3003 -b 192.168.2.57

ssh -p 1122 pdl@106.53.29.165

ihubTEST_!@#

bash /home/pdl/Update_ihubtestweb.sh
```

### ihub_server 同步git的脚本


```
ihub_server链接方式
#先链接到hk-gitlab服务器
ssh root@124.156.187.41 -p32222 密码 jBvZb824lea|[:C)
#链接ihub_server容器
ssh pdl@127.0.0.1 -p1123 密码pre123123
#上线
bash /home/pdl/update.sh
#代码目录
/home/pdl/ihub_server/
```

### ihub云脑版
```
云脑VPN

https://vpn.pcl.ac.cn/por/login_psw.csp?rnd=0.6812122517190504#http%3A%2F%2Fvpn.pcl.ac.cn%2F

账号 dengq
密码 dq123321


ssh pdl@192.168.201.14 -p1122
密码 code.ihub_567


ssh pdl@192.168.201.19 -p1122
密码 code.ihub_567

```

### ihub正式版的上线脚本
```
## ihub的默认用户手册链接：http://help.ihub.org.cn/
https://www.ihub.org.cn/

ssh forgeplus@106.52.19.68
pcl@openi1215

root密码： jBvZb824gEa|[:C)

上线脚本
scripts/update_repo_and_restart_nginx.sh

上线后sudo的密码

pcl@openi1215

项目的gitlab地址

http://testbdgit.educoder.net/
账号是     root 
密码是     12345678

http://bggit.ihub.org.cn/users/sign_in

账号是     root 
密码是     openi:lk6+406


#ihub项目的另一个服务器

http://123.207.90.229 (公)
root
OpenI0318iHub0718


iHub网页FTP：123.207.90.229
用户名：www_ihub_org_cn
密码：MiAWNLCci4YZ8cfd

https://www.kancloud.cn/setting/password
用户名：13302201096
密码：OpenI&iHub
```

curl --header "PRIVATE-TOKEN: priEn3UwXfJs3PmyXn_G" http://testbdgit.educoder.net/api/v3/projects

curl --request POST --header "PRIVATE-TOKEN: priEn3UwXfJs3PmyXn_G" "http://testbdgit.educoder.net/api/v3/license?license=eyJkYXRhIjoiMHM5Q...S01Udz09XG4ifQ=="


### 军科所的ssh账户密码

```
#阿里云版
1. web
sshpass -p TANGyi18510254886 ssh -o StrictHostKeyChecking=no -p 30123 root@39.105.176.215
2. 部署 链接上web后，通过pdl用户登录
ssh pdl@127.0.0.1 -p1122 / gcc@pd:lk0+1
3. 部署 sh script/junke.sh

#测试版
http://210.79.227.194/
#跳板机

ssh pdl@123.59.135.93  -p51123

junke_$$@#sd4%

sh script/junke.sh

# ssh账户

ssh pdl@210.79.227.194 -p1122 
gcc@pd:lk0+1

# 正式服务器的mysql数据库
junkeweb
mysql -uroot -h210.79.227.196 -Djunkeweb -p
Rott123_123


测试服务器：

ssh pdl@123.59.135.93  -p51123
密码： junke_$$@#sd4%

### 网易易盾的帐号

注册手机号：15190848375
用户名：jkymgcgl
密码：jkymgcgl20200810

易盾帐号/密码
15910848375
jkymgcgl20200810

# 开源方式的链接方式

forge
   sshpass -p pre123123 ssh -o StrictHostKeyChecking=no -p 1124 pdl@47.93.212.82
   http://47.93.212.82:49999/
gitea
   sshpass -p TANGyi18510254886 ssh -o StrictHostKeyChecking=no -p 30123 root@47.95.219.161
http://47.95.219.161:3000/
```
### Gitea的账户密码

```
https://testgitea.trustie.net/

xamppp@126.com
Sylor123456@
```



```

#初始的测试服务器
ssh pdl@123.59.135.93  -p51123

密码：  junke_$$@#sd4% 

上线脚本：script/junke.sh
```





#### 阿里云测试服务器的数据库链接


```
mysql -hrm-bp1ht3504joktie83rw.mysql.rds.aliyuncs.com -ueducoder -pTEST@123

# 设置最大的索引值
ALTER TABLE shixuns AUTO_INCREMENT=2652

#shixuns指需要修改的表，后面的数值表示最大的id
```




#### 1.新版服务器的登陆

```
ssh hs@47.98.32.78

密码：12345678

账户名：hs

邮箱: xamppp@126.com
```

#### 2.测试服务器的链接 

    ssh root@123.59.135.93 -p30122 

    输入密码 @pd:lk4+407

然后再输入

    ssh pdl@10.9.186.111 -p1122 

    密码 123123
    
#### 3. 阿里云服务器

```
http://47.96.87.25:48080

ssh  pdl@47.96.87.25  -p30122     #链接方式

@pd:lk3+407    #密码
```

#### 4.数据库账户密码:

```

mysql -h "rm-bp1ht3504joktie83rw.mysql.rds.aliyuncs.com" -ueducoder -pTEST@123    //新版服务器链接数据库


mysql -h10.9.70.25 -uroot -pTrust_#%01

testbdweb   #数据库名称
```

#### 5.账户名称密码

学生： 15607310002    edu12345678

#### 6. 新版react的路径

```
http://117.50.13.128:8889/yangSir/newreactbuild.git
```

#### 7. 新版临时地址

```
http://47.96.87.25:48080/shixuns
```

### 8. 源码地址及分支


```
# ihub 
https://git.trustie.net/Hjqreturn/forgeplus.git 
分支: openi

# ihub gitlab 代码
http://gitea.trustie.net/SylorHuang/ihub_server.git
分支: master

# 绿盟 
https://git.trustie.net/Hjqreturn/forgeplus.git 
分支: develop


# 军科 
http://git.trustie.net/jasder/military-server.git
分支: ding_local

# forgeplus
...
```


