FROM nginx:alpine-perl AS builder

LABEL maintainer="VVavE Docker Maintainers <waveworkshop@outlook.com>"
# ENV NGINX_VERSION 1.17.5
# ENV NJS_VERSION   0.3.6
# ENV PKG_RELEASE   1

ENV NCHAN_VERSION 1.2.6
ENV NGX_BROTLI_COMMIT e505dce68acc190cc5a1e780a3b0275e39f160ca
ENV NGX_NCHAN_COMMIT 11e718227aa1a7a448b688f801d380dbc612349a
ENV NGX_HEADERS_COMMIT 552e216a0da95c685d9db4f43e209c3f2a803e49

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        perl-dev \
        libedit-dev \
        mercurial \
        bash \
        alpine-sdk \
        findutils \
        git \
        curl \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/google/ngx_brotli.git \
    && git clone --recursive https://github.com/openresty/headers-more-nginx-module.git \
    && git clone --recursive https://github.com/slact/nchan.git \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && NGX_BROTLI_DIR="$(pwd)/ngx_brotli" \
    && NGX_HEADER_DIR="$(pwd)/headers-more-nginx-module" \
    && NCHAN_DIR="$(pwd)/nchan" \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
        --user=nginx \
        --group=nginx \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module --with-mail \
        --with-mail_ssl_module --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --add-dynamic-module=$NGX_BROTLI_DIR \
        --add-dynamic-module=$NGX_HEADER_DIR \
        --add-dynamic-module=$NCHAN_DIR \
        --with-cc-opt='-Os -fomit-frame-pointer' \
        --with-ld-opt=-Wl,--as-needed \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && strip /usr/lib/nginx/modules/*.so \
    && rm -rf /usr/src/

FROM nginx:alpine-perl

# Extract the dynamic module NCHAN from the builder image
COPY --from=builder /usr/lib/nginx/modules/ngx_nchan_module.so /usr/lib/nginx/modules/ngx_nchan_module.so
COPY --from=builder /usr/lib/nginx/modules/ngx_http_brotli_filter_module.so /usr/lib/nginx/modules/ngx_http_brotli_filter_module.so
COPY --from=builder /usr/lib/nginx/modules/ngx_http_brotli_static_module.so /usr/lib/nginx/modules/ngx_http_brotli_static_module.so
COPY --from=builder /usr/lib/nginx/modules/ngx_http_headers_more_filter_module.so /usr/lib/nginx/modules/ngx_http_headers_more_filter_module.so

RUN apk add --no-cache iproute2

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
