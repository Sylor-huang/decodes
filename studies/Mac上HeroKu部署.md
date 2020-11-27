1. 安装heroku

```
curl https://cli-assets.heroku.com/install.sh | sh
```


```
heroku --version   #查看版本
heroku login -i   #登录

heroku create fedmob   # 在项目目录下创建heroku app

git push heroku master   #推送到heroku

heroku psql  #进入pg数据库

heroku rake db:schema:load
```

 