# 基于 C++11 的高并发数据库连接池

一个从零实现的 MySQL 连接池示例项目，使用 `C++11 + MySQL C API + CMake` 构建，提供了本地编译方式和基于 Docker Compose 的一键验证方式。

当前仓库既适合作为连接池实现的学习样例，也适合作为后续聊天服务器、业务服务的数据访问基础模块。

## 项目特点

- 使用 `std::shared_ptr<MySQL>` 和自定义删除器实现连接自动归还
- 使用生产者 / 消费者双条件变量降低高并发下的无效唤醒
- 支持按配置预热连接、按需补充连接
- 支持配置文件解析与合法性校验
- 支持通过 Docker Compose 快速拉起 MySQL 并完成验证

## 目录结构

```text
.
├── CMakeLists.txt
├── Dockerfile
├── docker-compose.yml
├── autobuild.sh
├── config/
│   └── connection_pool.conf.example
├── docker/mysql/init/
│   └── 01-init-connection-pool.sql
├── example/
│   └── main.cpp
├── include/
└── src/
```

## 运行前说明

- 程序实际读取的配置文件是 `config/connection_pool.conf`
- 仓库中只保留模板文件 `config/connection_pool.conf.example`
- 如果本地直接运行，请先复制模板并按你的环境修改
- Docker 方式会在镜像构建时自动从模板生成运行配置
- 对当前仓库来说：
  - 容器内运行时使用 `mysql_db` 作为数据库地址
  - 宿主机本地运行时，如果连接的是 Docker 暴露出来的 MySQL，则应使用 `127.0.0.1:3306`

说明：当前 `example/main.cpp` 主要用于并发借还连接测试，重点验证“连接能否成功建立与复用”；它不会依赖额外业务表结构，因此用一个空的 MySQL 数据库也可以跑通。

## 本地编译运行

### 依赖

- C++11 编译器
- CMake 3.10+
- MySQL 客户端开发库，例如 Ubuntu 上的 `libmysqlclient-dev`

### 步骤

```bash
bash ./autobuild.sh
./bin/test_pool
```

如果你没有本地安装 MySQL，也可以先启动 Docker 中的数据库容器，再在宿主机运行本程序。此时本地配置应类似：

```conf
ip=127.0.0.1
port=3306
username=connection_pool_app
password=wang112233
dbname=connection_pool_dev
```

## Docker Compose 运行

### 这套编排会启动什么

- `cpp_app`：编译并运行示例程序
- `mysql_db`：官方 `mysql:8.0` 数据库容器
- `mysql_data`：MySQL 数据卷，用于持久化数据库数据

### 初始化内容

MySQL 首次启动时会执行：

- [docker/mysql/init/01-init-connection-pool.sql](docker/mysql/init/01-init-connection-pool.sql)

它会创建：

- 数据库：`connection_pool_dev`
- 用户：`connection_pool_app`
- 密码：`wang112233`

`config/connection_pool.conf.example` 默认已经指向 Docker Compose 服务名 `mysql_db`，因此容器之间可以直接通信。

说明：Docker 容器里的应用连接数据库时使用 `mysql_db`；如果你是在宿主机直接运行 `./bin/test_pool`，则应连接 Docker 映射出来的 `127.0.0.1:3306`。

### 启动

```bash
docker compose up --build
```

### 常用命令

后台启动：

```bash
docker compose up -d --build
```

查看服务状态：

```bash
docker compose ps
```

查看日志：

```bash
docker compose logs -f
```

停止并删除容器：

```bash
docker compose down
```

如果你修改了初始化 SQL、数据库用户名或密码，希望让 MySQL 从零重新初始化：

```bash
docker compose down -v
docker compose up --build
```

## 关键设计说明

### 为什么 Docker 内不能写 `127.0.0.1`

在 Docker Compose 网络中：

- `127.0.0.1` 表示当前容器自己
- `mysql_db` 才表示 MySQL 服务容器

所以应用配置里必须写：

```conf
ip=mysql_db
```

### 为什么需要 `healthcheck`

`depends_on` 只能保证启动顺序，不能保证 MySQL 已经完成初始化。  
本项目在 `docker-compose.yml` 中为 `mysql_db` 配置了健康检查，只有数据库真正可连接后，`cpp_app` 才会启动。

### 为什么需要数据卷

MySQL 数据存放在容器内的 `/var/lib/mysql`。  
通过 `mysql_data` 数据卷挂载后，即使容器删除，数据库数据仍然可以保留。

## 成功运行的标志

当你看到以下现象时，说明项目已经跑通：

- `mysql_db` 变成 `Healthy`
- 日志里出现初始化 SQL 执行信息
- `cpp_app` 输出多条“成功拿到连接”
- 最终出现 `cpp_app exited with code 0`

这里的 `exited with code 0` 是正常结束，不是失败。因为当前示例程序属于一次性压力测试，跑完就退出。

## 适合继续扩展的方向

- 增加真实 SQL 读写测试，而不只是连接借还测试
- 为连接对象增加空闲超时回收机制
- 引入更多运行时指标，例如活跃连接数、等待次数、超时次数
- 将当前连接池库接入聊天服务器或其他业务服务
