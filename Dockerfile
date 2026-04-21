FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . .

# 使用示例配置生成容器内运行配置，避免依赖宿主机本地私有文件
# 同时清理可能被带进来的旧构建产物，防止 CMake 缓存路径冲突
RUN cp config/connection_pool.conf.example config/connection_pool.conf \
    && rm -rf build bin \
    && cmake -S . -B build \
    && cmake --build build -j

CMD ["./bin/test_pool"]
