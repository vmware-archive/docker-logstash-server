FROM logstash:1.5.3
MAINTAINER Tom Scanlan <tscanlan@vmware.com>

RUN apt-get update
RUN apt-get install -y dnsutils netcat

ADD http://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 /bin/confd
ADD start.sh /start.sh

ENTRYPOINT /start.sh
