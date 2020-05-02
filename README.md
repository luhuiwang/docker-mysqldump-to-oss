# docker-mysqldump-to-oss

## 功能
利用Docker容器实现定期自动将远程MySQL数据库备份到阿里云OSS存储中。

## 工具
`Docker`/`Docker-Compose`，`mysql-client`/`mysqldump`，`Ossutil`。

## 使用
1. 补充`docker-compose.yml`中的环境变量；
2. 更改定期周期：如`每分钟`为`/etc/periodic/1min`、`每天`为`/etc/periodic/daily`，具体参考[nralbers/scheduler](https://github.com/nralbers/docker-scheduler#usage)；
3. 构建镜像：`docker-compose build`；
4. 启动服务：`docker-compose up -d`；
5. 查看日志：`docker-compose logs -f`；
6. 卸载服务：`docker-compose down`。

## 参考
- [nralbers/scheduler](https://github.com/nralbers/docker-scheduler)
- [mysqldump-to-s3](https://github.com/ianneub/mysqldump-to-s3)