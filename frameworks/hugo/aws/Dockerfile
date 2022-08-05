# Docker image to help with local testing
# To build this locally, run: `docker build -t blog -f frameworks/hugo/aws/Dockerfile .` from the project root
FROM amazonlinux:2

RUN amazon-linux-extras install -y nginx1.12
RUN yum install -y git

COPY frameworks/hugo/aws/scripts/01_bootstrap.sh /var/hugo-blog/bootstrap.sh