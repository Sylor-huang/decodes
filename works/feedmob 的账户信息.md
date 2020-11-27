#### 1. 开发环境的redshift数据库地址
```
redshift://fb_test:f862A&b6c%23d%25d72@fb-test.c7oalhm9rmgx.us-east-1.redshift.amazonaws.com/dev
```

#### 2. stage环境sidekiq的账户密码

```ruby
https://stage-worker.feedmob.info/sidekiq
feedmob / devteamsecret
```

#### 3. feedmob_worker的ssh命令

```
ssh deploy@3.88.85.228
```

#### 4. 个人主机

```
sylor@3.237.1.167
```

#### 5. snowflake的数据库链接方式

```
https://uk84765.snowflakecomputing.com
username: roofeel
password: Zl.123456

usename: sylor
password: Xamppp8808
```

#### 6. newrelic的账户密码

```
https://one.newrelic.com
support@techbay.club / Welcometechb@y
```

#### 7. 早晚会地址
```
早会 https://meet.google.com/_meet/rmd-wdrt-qbz
晚会 https://meet.google.com/auy-srgq-gds

```

#### 8. 数据库的记录

```
我们数据库分为 main 库和 conversion 库哈。admin 设置到配置的都在 main 库 (如， click_url, campaign, vendor 等)
9:17
我们 conversion records 的数据 和 stat_records 的数据是在 conversion 库
```

#### 9. feedmob_score的数据库

```
DATABASE_URL: 'postgres://fb_pro:Q3Ds596uog@fb-score-ds-dev.cgb5t3jqdx7r.us-east-1.rds.amazonaws.com/fb_score_pro'
```

#### 10. git rebase -i Head~2