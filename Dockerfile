FROM node:11-alpine as builder

# Install dependencies for alpine
COPY ./docker_build/repositories /etc/apk/repositories
RUN apk update && apk add --no-cache  git python make openssl tar gcc

# Copy source code and set workdir
COPY . /api/vendors
WORKDIR /api/vendors
RUN npm install --production --registry https://registry.npm.taobao.org

FROM node:11-alpine

MAINTAINER Ryan Miao
ENV TZ="Asia/Shanghai" HOME="/"
WORKDIR ${HOME}

COPY --from=builder /api/vendors /api/vendors
COPY ./docker_build/config.json /api/
EXPOSE 3001

COPY ./docker_build/docker-entrypoint.sh /api/
RUN chmod 755 /api/docker-entrypoint.sh

ENTRYPOINT ["/api/docker-entrypoint.sh"]




