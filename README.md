# docker-logstash-server

Builds a docker image for running logstash-server in container.

## Requirements

A working Docker setup and a valid shell (e.g., bash).

An elasticsearch cluster must be running.

To join an existing cluster, run a registrator container beside this container
and pass in the SERVICENAME="elasticsearch-9300.service.consul" or similar for
the elastic search service pool.

## Getting Started
Build the container and run it.

```
./build.sh
docker run -d vmware-opencloud/logstash-server
```

By default, we join any running containers in elasticsearch-9300.service.consul
running with CLUSTERNAME="default&#95;clustername".  We use DNS SRV records
to identify the nodes in the cluster to join. Set SERVICENAME environment variable
to a SVR record, or to the consul service name for the pool, which is the same thing.

After upping the logstash server, you can send logs to it and those will be forwarded
on to the elasticsearch cluster at $SERVICENAME


## Example

```
docker run -d gliderlabs/registrator:master
docker run -d vmware-opencloud/logstash-server
```

## License

TBD

## Author Information

This role was created in 2015 by [Tom Scanlan / VMware](http://www.vmware.com/).
