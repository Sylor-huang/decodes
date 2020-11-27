### udask的上线步骤


```
source /etc/profile
service nginx start
service mysql start
redis-server --protected-mode no --daemonize yes
service elasticsearch start
RAILS_ENV=production bundle exec sidekiq -d

RAILS_ENV=production rails s

#searchkick 启动
RAILS_ENV=production rake searchkick:reindex:all

```


### margin的上线步骤

www.marinedrug.zjut.edu.cn

```
docker exec -it 2728068a4952 /bin/bash

source /etc/profile

service nginx start

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

service mysql start

cd /root/marinedrug2

RAILS_ENV=production rails s

```


```
docker 复制宿主机到容器内

docker cp /root/marinedrug2/ 容器id:/root
```

