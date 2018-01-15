[![Build Status](https://travis-ci.org/evilmartians/chef-prometheus-exporters.svg?branch=master)](https://travis-ci.org/evilmartians/chef-prometheus-exporters)

# prometheus_exporters

Cookbook to install and configure various Prometheus exporters on systems to be monitored by Prometheus.

Currently supported exporters are node, postgres, redis and snmp. More may be added in the future. Please contact the author if you have specific requests.

All of the exporters are available as chef custom resources that can be instantiated from other cookbooks.


# Supports

* Ubuntu 14.04
* Ubuntu 16.04
* CentOS 6
* CentOS 7

And probably other RHEL or Debian based distributions.

Tests are made using last available Chef 12 (12.21.14) along with latest Chef 13.

# Resources

## node_exporter

* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9100")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]
* `log_format` Where to send log files. (default: "logger:stdout")
* `collectors_enabled` An array of explicitly enabled collectors.
* `collectors_disabled` An array of explicitly disabled collectors.
* `collector_megacli_command` Command to run megacli. (default: "megacli")
* `collector_ntp_server` NTP server to use for ntp collector. (default: "127.0.0.1")
* `collector_ntp_protocol_version` NTP protocol version. (default: "4")
* `collector_ntp_server_is_local` Certify that collector.ntp.server address is the same local host as this collector.
* `collector_ntp_ip_ttl` IP TTL to use while sending NTP query. (default: "1")
* `collector_ntp_max_distance` Max accumulated distance to the root. (default: "3.46608s")
* `collector_ntp_local_offset_tolerance` Offset between local clock and local ntpd time to tolerate. (default: "1ms")
* `path_procfs` procfs mountpoint. (default: "/proc")
* `path_sysfs` sysfs mountpoint. (default: "/sys")
* `collector_textfile_directory` Directory to read text files with metrics from. (default: "")
* `collector_netdev_ignored_devices` Regexp of net devices to ignore for netdev collector. (default: "")
* `collector_diskstats_ignored_devices` Regexp of devices to ignore for diskstats. (default: "^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$")
* `collector_filesystem_ignored_fs_types` Regexp of filesystem types to ignore for filesystem collector. (default: "^(sys|proc|auto)fs$")
* `collector_filesystem_ignored_mount_points` Regexp of mount points to ignore for filesystem collector. (default: "^/(sys|proc|dev)($|/)")
* `custom_options` Use for your configuration if defined proterties are not satisfying your needs.

```ruby

listen_ip = '127.0.0.1'

node_exporter 'main' do
  web_listen_address "#{listen_ip}:9100"
  action [:enable, :start]
end
```

or just set

* `node['prometheus_exporters']['listen_interface']`
* `node['prometheus_exporters']['node']['collectors']`
* `node['prometheus_exporters']['node']['textfile_directory']`
* `node['prometheus_exporters']['node']['ignored_net_devs']`

and add `recipe['prometheus_exporters::node]` to your run_list.

## postgres_exporter

The postgres_exporter resource supports running multiple copies of PostgreSQL exporter the same system. This is useful if you have multiple copies of PostgreSQL running on the same system
(eg. different versions) or you are connecting to multiple remote PostgreSQL servers across the network.

* `instance_name` name of PostgreSQL exporter instance. (**name attribute**)
* `data_source_name` PostgreSQL connection string. E.g. `postgresql://login:password@hostname:port/dbname`
* `extend_query_path` Path to custom queries to run
* `log_format` If set use a syslog logger or JSON logging. Example: logger:syslog?appname=bob&local=7 or logger:stdout?json=true. Defaults to stderr.
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal].
* `web_listen_address` Address to listen on for web interface and telemetry. (default "127.0.0.1:9187")
* `web_telemetry_path` Path under which to expose metrics. (default "/metrics")
* `user` System user to run exporter as. (default "postgres")

```ruby

postgres_exporter '9.5_main' do
  data_source_name 'postgresql://localhost:5432/example'
  user 'postgres'
end
```

## redis_exporter

* `web_listen_address` Address to listen on for web interface and telemetry. (default: "0.0.0.0:9121")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")
* `log_format` In what format should logs be shown. (default: "txt")
* `debug` Enable or disable debug output. (default: false)
* `check_keys` Comma separated list of keys to export value and length/size, eg: `db3=user_count` will export key `user_count` from db `3`. db defaults to `0` if omitted. (default: "")
* `redis_addr` Address of one or more redis nodes, comma separated. (default: "redis://localhost:6379")
* `redis_password` Password to use when authenticating to Redis. (default: "")
* `redis_alias` Alias for redis node addr, comma separated. (default: "")
* `redis_file`  Path to file containing one or more redis nodes, separated by newline. This option is mutually exclusive with redis.addr. Each line can optionally be comma-separated with the fields.
* `namespace` Namespace for the metrics. (defaults "redis")
* `user` User under whom to start redis exporter. (default: "root")

```ruby
redis_exporter 'main' do
  redis_addr 'redis://db01.example.com:6379,redis://10.0.0.1:6379'
  redis_password 'password_one,password_two'
  redis_alias 'example_production,example_staging'
end
```

## snmp_exporter

This exporter needs a custom generated config file. Read more [here](https://github.com/prometheus/snmp_exporter#configuration) and [here](https://github.com/prometheus/snmp_exporter/tree/master/generator). For test purposes and the most basic usage you can grab a default `snmp.yml` which is located here: `/opt/snmp_exporter-PASTE_CURRENT_VERSION.linux-amd64/snmp.yml`

* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9116")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]
* `log_format` Where to send log files. (default: "logger:stdout")
* `config_file` default: '/etc/snmp_exporter/snmp.yaml'
* `custom_options` Any other raw options for your configuration if defined proterties are not satisfying your needs.

```ruby
snmp_exporter 'main' do
  config_file "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp.yml"
end
```

# Known Issues

* The snmp_exporter requires a configuration file that is usually created by a config generator. Currently this functionality must be provided by a wrapper cookbook.
