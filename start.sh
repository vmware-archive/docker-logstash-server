#!/bin/sh

LISTEN_PORT=8514

if [ -z "${CLUSTERNAME}" ]; then
	CLUSTERNAME="default_clustername"
fi
if [ -z "${SERVICENAME}" ]; then
	SERVICENAME="elasticsearch-9300.service.consul"
fi

hosts=`dig $SERVICENAME SRV | awk "/^$SERVICENAME/ {print \"\x22\" \\$8 \":\" \\$7 \"\x22\" }" | sed 's/\.:/:/g;' | sed ':a;N;$!ba;s/\n/,/g;'`; echo $hosts

mkdir /config-dir
cat > /config-dir/logstash.conf <<EOF
input {
  syslog {
   port => "$LISTEN_PORT"
  }
}
output {
  stdout { codec => rubydebug }

  elasticsearch {
    cluster => "$CLUSTERNAME"
    # comma separated list of elasticsearch hosts
    host => [$hosts]
    protocol => "transport"
    sniffing => true
  }
}
EOF

exec /docker-entrypoint.sh logstash -f /config-dir/logstash.conf "$@"
