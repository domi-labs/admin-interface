# # 使用官方 Node.js 10 运行时作为父镜像
# FROM node:10-alpine as build

# WORKDIR /app

# # 将 package.json 和 package-lock.json 文件复制到容器中
# COPY package*.json ./

# # 安装依赖
# RUN npm install

# # 复制项目源代码
# COPY . .

# # 构建 Vue 应用
# RUN npm run build

# # 使用 nginx 作为生产环境服务
# FROM nginx:latest

# # 替换默认的 nginx 配置文件
# COPY nginx.conf /etc/nginx/nginx.conf

# # 将构建产物复制到 nginx 的 html 目录
# COPY --from=build /app/dist /usr/share/nginx/html

# 使用官方node镜像作为基础镜像
FROM node:10

# 设置工作目录
WORKDIR /app

# 复制package.json和package-lock.json到工作目录
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制所有文件到工作目录
COPY . .

# 构建应用
RUN npm run build

# 使用官方nginx镜像作为基础镜像
FROM nginx:alpine

# 复制构建后的文件到nginx的html目录
COPY --from=0 /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
