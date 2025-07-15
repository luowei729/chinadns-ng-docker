# 使用 Alpine Linux 作为基础镜像
FROM alpine:latest

# 设置工作目录 (可选，但推荐)
WORKDIR /chinadns

# 将你的二进制文件和配置文件复制到容器中
COPY chinadns-ng /chinadns/
RUN chmod +x /chinadns/chinadns-ng
COPY chnroute.conf /chinadns/
COPY res/chnlist.txt /chinadns/chnlist.txt
COPY res/gfwlist.txt /chinadns/gfwlist.txt
COPY res/chnroute.ipset /chinadns/chnroute.ipset
COPY res/chnroute6.ipset /chinadns/chnroute6.ipset

# 安装运行 app 需要的依赖库
RUN apk update && apk add --no-cache libc6-compat && apk add --no-cache ipset

# 创建一个脚本来初始化 ipset 并启动 chinadns-ng
RUN echo "#!/bin/sh" > /chinadns/run.sh && \
    echo "set -e" >> /chinadns/run.sh && \
    echo "ipset -R < /chinadns/chnroute.ipset" >> /chinadns/run.sh && \
    echo "ipset -R < /chinadns/chnroute6.ipset" >> /chinadns/run.sh && \
    echo "exec /chinadns/chinadns-ng -C /chinadns/chnroute.conf" >> /chinadns/run.sh && \
    chmod +x /chinadns/run.sh

# 设置启动命令：容器启动时执行你的程序
CMD ["/chinadns/run.sh"]
