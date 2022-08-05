#!/usr/bin/env bash
set -x -e

# TODO: verify checksum
curl -L https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_0.55.6_Linux-64bit.tar.gz -o /tmp/hugo_0.55.6_Linux-64bit.tar.gz
mkdir -p /tmp/hugo-install
tar -xzf /tmp/hugo_0.55.6_Linux-64bit.tar.gz -C /tmp/hugo-install
mv /tmp/hugo-install/hugo /usr/bin

# Create the source dir
mkdir -p /var/hugo-blog/blog
cd /var/hugo-blog/blog
git clone --verbose --recurse-submodules https://gitlab.com/jsanders67/sanjams-hugo-blog.git

# Build site
cd sanjams-hugo-blog
hugo >&2

# configure nginx via the default config
# with a modified root directory
amazon-linux-extras install -y nginx1.12
mkdir -p /var/www/html
cat << 'EOF' > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /var/www/html;

        include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
EOF
service nginx start

# Copy binaries
cp -R public/* /var/www/html

# Configure cronjob
cat << 'EOF' | crontab -
* * * * * bash /var/hugo-blog/update.sh 2>&1
EOF