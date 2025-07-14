# 使用 Alpine Linux 作为基础镜像
FROM alpine:latest

# 设置工作目录 (可选，但推荐)
WORKDIR /chinadns

# 将你的二进制文件和配置文件复制到容器中
COPY chinadns-ng /chinadns/
RUN chmod +x /chinadns/chinadns-ng
COPY chnroute.conf /chinadns/
COPY /res/chnlist.txt /chinadns/chnlist.txt
COPY /res/gfwlist.txt /chinadns/gfwlist.txt


# 安装运行 app 需要的依赖库
RUN apk update && apk add --no-cache libc6-compat && apk add --no-cache ipset

# 设置启动命令：容器启动时执行你的程序
CMD ["/chinadns/chinadns-ng", "-C", "/chinadns/chnroute.conf"]
