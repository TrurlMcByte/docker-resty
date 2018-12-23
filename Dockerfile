FROM openresty/openresty:alpine-fat

MAINTAINER Trurl McByte "trurl@mcbyte.net"

RUN apk add --no-cache --virtual .run-deps \
    bash \
    curl \
    jq \
    diffutils \
    grep \
    sed \
    libmaxminddb \
    imagemagick \
    imagemagick-dev \
    openssl \
    && mkdir -p /etc/resty-auto-ssl \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && chown nginx /etc/resty-auto-ssl

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        gnupg \
        libmaxminddb-dev \
        libxslt-dev \
        gd-dev \
        perl-dev \
        tar \
        unzip \
        zip \
        unzip \
        g++ \
        cmake \
        lua \
        lua-dev \
        make \
        autoconf \
        automake \
    && /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl \
    && /usr/local/openresty/luajit/bin/luarocks install magick \
    && /usr/local/openresty/bin/opm get anjia0532/lua-resty-maxminddb \
    && cd /usr/local/openresty/luajit/share/lua/5.1/magick/wand/ \
    && curl -O https://raw.githubusercontent.com/TrurlMcByte/magick/MagickCompositeImageGravity/magick/wand/image.lua \
    && curl -O https://raw.githubusercontent.com/TrurlMcByte/magick/MagickCompositeImageGravity/magick/wand/lib.lua \
    && apk del .build-deps \
    && ln -s /usr/lib/libmaxminddb.so.0 /usr/lib/libmaxminddb.so \
    && ln -s /usr/lib/libmagic.so.1 /usr/lib/libmagic.so \
    && rm -rf /usr/local/openresty/nginx/conf/* \
    && mkdir -p /var/cache/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY resty.conf /usr/local/openresty/nginx/conf/nginx.conf

CMD ["/usr/local/openresty/bin/openresty", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
