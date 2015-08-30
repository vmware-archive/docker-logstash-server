#!/bin/sh
#
#  Copyright 2015 VMware, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

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
