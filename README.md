# prometheus_exporters

Cookbook to install and configure various Prometheus exporters on systems to be monitored by Prometheus.

Currently supported exporters are node, postgres, redis, mysqld, haproxy, process, apache, blackbox, snmp, statsd, and wmi. More may be added in the future. Please contact the author if you have specific requests.

All of the exporters are available as chef custom resources that can be instantiated from other cookbooks.


# Supports

* Ubuntu 16.04
* Ubuntu 18.04
* Fedora 31
* Fedora 30
* Debian 4
* Debian 9
* CentOS 7
* Amazon Linux

And probably other RHEL or Debian based distributions.

* Windows Server 2012 & 2016 (wmi\_exporter recipe only)

Tests are made using last available Chef 15 along with latest Chef 14.

# Resource List

- [apache_exporter](https://github.com/evilmartians/chef-prometheus-exporters#apache_exporter)
- [blackbox_exporter](https://github.com/evilmartians/chef-prometheus-exporters#blackbox_exporter)
- [consul_exporter](https://github.com/evilmartians/chef-prometheus-exporters#consul_exporter)
- [elasticsearch_exporter](https://github.com/evilmartians/chef-prometheus-exporters#elasticsearch_exporter)
- [haproxy_exporter](https://github.com/evilmartians/chef-prometheus-exporters#haproxy_exporter)
- [mongodb_exporter](https://github.com/evilmartians/chef-prometheus-exporters#mongodb_exporter)
- [mysqld_exporter](https://github.com/evilmartians/chef-prometheus-exporters#mysqld_exporter)
- [node_exporter](https://github.com/evilmartians/chef-prometheus-exporters#node_exporter)
- [postgres_exporter](https://github.com/evilmartians/chef-prometheus-exporters#postgres_exporter)
- [process_exporter](https://github.com/evilmartians/chef-prometheus-exporters#process_exporter)
- [rabbitmq_exporter](https://github.com/evilmartians/chef-prometheus-exporters#rabbitmq_exporter)
- [redis_exporter](https://github.com/evilmartians/chef-prometheus-exporters#redis_exporter)
- [snmp_exporter](https://github.com/evilmartians/chef-prometheus-exporters#snmp_exporter)
- [statsd_exporter](https://github.com/evilmartians/chef-prometheus-exporters#statsd_exporter)
- [varnish_exporter](https://github.com/evilmartians/chef-prometheus-exporters#varnish_exporter)
- [wmi_exporter](https://github.com/evilmartians/chef-prometheus-exporters#wmi_exporter)
- [nginx_exporter](https://github.com/evilmartians/chef-prometheus-exporters#nginx_exporter)
# Resources

## apache_exporter

* `insecure` Ignore server certificate if using https. (default false)
* `log_format` Output format of log messages. e.g. "logger:syslog?appname=bob&local=7" or "logger:stdout?json=true" (default: "logger:stdout")
* `log_level` The logging level. (default: "info")
* `scrape_uri` URI to apache stub status page. (default "http://localhost/server-status/?auto")
* `telemetry_address` Address on which to expose metrics. (default ":9117")
* `telemetry_endpoint` Path under which to expose metrics. (default "/metrics")
* `user` User under whom to start apache exporter. (default: "root")

```ruby
apache_exporter 'main' do
  scrape_uri "http://localhost:8090/server-status/?auto"
  telemetry_address ":9118"
  telemetry_endpoint "/_metrics"
end
```

## blackbox_exporter

This exporter requires a config file. Read more [here](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md). For basic usage the default `blackbox.yml` should be sufficient.

* `config_file` default: `/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml`
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error]
* `timeout_offset` default: 0.5 Offset to subtract from timeout in seconds.
* `user` User under whom to start blackbox exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9115")

```ruby
blackbox_exporter 'main'
```

## consul_exporter

* `consul_allow_stale` Allows any Consul server (non-leader) to service a read. (default: false)
* `consul_ca_file` File path to a PEM-encoded certificate authority used to validate the authenticity of a server certificate.
* `consul_cert_file` File path to a PEM-encoded certificate used with the private key to verify the exporter's authenticity.
* `consul_health_summary` Collects and exports information about each registered service. (default: false)
* `consul_insecure` Disable TLS host verification. (default: false)
* `consul_key_file` File path to a PEM-encoded private key used with the certificate to verify the exporter's authenticity.
* `consul_require_consistent` Enforce fully consistency on Consul reads. (default: false)
* `consul_server_name` Override the hostname for the TLS certificate. It can be used to ensure that the certificate name matches the decalred hostname.
* `consul_server` Address of the Consul instance to connect to. (default: "http://localhost:8500")
* `consul_timeout` Timeout on HTTP requests to consul. (default: "500ms")
* `kv_prefix` Prefix from which to expose key/value pairs.
* `kv_filter` Regex that determines which keys to expose. (default: ".*")
* `log_format` Output format of log messages. One of: [logfmt, json]. (default: "logfmt")
* `log_level` The logging level. (default: "info")
* `user` User under whom to start elasticsearch exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9107")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

```ruby
consul_exporter 'main' do
  action %i[install enable start]
end
```

## elasticsearch_exporter

* `es_all` If true, query stats for all nodes in the cluster, rather than just the node we connect to. (default: false)
* `es_ca` Path to PEM file that contains trusted Certificate Authorities for the Elasticsearch connection.
* `es_client_cert` Path to PEM file that contains the corresponding cert for the private key to connect to Elasticsearch.
* `es_client_private_key	` Path to PEM file that contains the private key for client auth when connecting to Elasticsearch.
* `es_cluster_settings` If true, query stats for cluster settings. (default: false)
* `es_clusterinfo_interval` Cluster info update interval for the cluster label. (default: 5m)
* `es_indices_settings` If true, query settings stats for all indices in the cluster. (default: false)
* `es_indices` If true, query stats for all indices in the cluster. (default: false)
* `es_shards` If true, query stats for all indices in the cluster, including shard-level stats (implies es.indices=true). (default: false)
* `es_snapshots` If true, query stats for the cluster snapshots. (default: false)
* `es_ssl_skip_verify` Skip SSL verification when connecting to Elasticsearch. (default: false)
* `es_timeout` Timeout for trying to get stats from Elasticsearch. (ex: 20s) (default: 5s)
* `es_uri` Address (host and port) of the Elasticsearch node we should connect to. (default: "http://localhost:9200")
* `log_format` Set the log target and format. Valid values are: [json, logfmt]
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]
* `user` User under whom to start elasticsearch exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9114")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

```ruby
elasticsearch_exporter 'main' do
  action %i[install enable start]
end
```

## haproxy_exporter

Monitor HAProxy metrics and stats. Read more [here](https://github.com/prometheus/haproxy_exporter).

* `haproxy_pid_file` Path to HAProxy pid file.
* `haproxy_scrape_uri` URI on which to scrape HAProxy.
* `haproxy_server_metric_fields` Comma-separated list of exported server metrics.
* `haproxy_ssl_verify` Flag that enables SSL certificate verification for the scrape URI.
* `haproxy_timeout` Timeout for trying to get stats from HAProxy.
* `log_format` Where to send log files. (default: "logger:stdout")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]. (default: "info")
* `user` User under whom to start haproxy exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. (default: "0.0.0.0:9116")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

```ruby
haproxy_exporter 'main' do
  haproxy_scrape_uri 'http://user:pass@haproxy.example.com/haproxy?stats;csv'
end

haproxy_exporter 'main' do
  haproxy_scrape_uri 'unix:/run/haproxy/admin.sock'
  user 'haproxy'
end
```

Use the given defaults or set the attributes...

* `node['prometheus_exporters']['listen_interface']`
* `node['prometheus_exporters']['haproxy']['port']`
* `node['prometheus_exporters']['haproxy']['scrape_uri']`
* `node['prometheus_exporters']['haproxy']['ssl_verify']`
* `node['prometheus_exporters']['haproxy']['user']`

and add `recipe['prometheus_exporters::haproxy]` to your run_list.

## mongodb_exporter

* `collect_collection` Enable collection of Collection metrics
* `collect_connpoolstats` Collect MongoDB connpoolstats
* `collect_database` Enable collection of Database metrics
* `collect_indexusage` Enable collection of per index usage stats
* `collect_topmetrics` Enable collection of table top metrics
* `log_format` Set the log target and format. Example: "logger:syslog?appname=bob&local=7" or "logger:stdout?json=true"
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]
* `mongodb_authentication_database` Specifies the database in which the user is created
* `mongodb_max_connections` Max number of pooled connections to the database. (default: 1)
* `mongodb_socket_timeout` Amount of time to wait for a non-responding socket to the database before it is forcefully closed. Valid time units are 'ns', 'us' (or 'µs'), 'ms', 's', 'm', 'h'. (default: 3s)
* `mongodb_sync_timeout` Amount of time an operation with this session will wait before returning an error in case a connection to a usable server can't be established. (default: 1m)
* `mongodb_uri` MongoDB URI, format ([mongodb://][user:pass@]host1[:port1][,host2[:port2],...][/database][?options])
* `user` User under whom to start mongodb exporter. (default: "root")
* `web_auth_file` Path to YAML file with server_user, server_password keys for HTTP Basic authentication (overrides HTTP_AUTH environment variable).
* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9216")
* `web_ssl_cert_file` Path to SSL certificate file.
* `web_ssl_key_file` Path to SSL key file.
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

```ruby
mongodb_exporter 'main' do
  action %i[install enable start]
end
```

## mysqld_exporter

The mysqld_exporter resource supports running multiple copies of the MySQL exporter on the same system.

* `collector_flags` Specify which collector flags you wish to use. default: see belo
* `config_my_cnf` Path to .my.cnf file to read MySQL credentials from. (default: ~/.my.cnf)
* `data_source_name` MySQL connection string
* `instance_name` name of MySQL exporter instance. (**name attribute**)
* `log_format` If set use a syslog logger or JSON logging. Example: logger:syslog?appname=bob&local=7 or logger:stdout?json=true. Defaults to stderr.
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal].
* `user` System user to run exporter as. (default "mysql")
* `web_listen_address` Address to listen on for web interface and telemetry. (default "127.0.0.1:9104")
* `web_telemetry_path` Path under which to expose metrics. (default "/metrics")

(default collector flags)

```
'\
-collect.global_status \
-collect.engine_innodb_status \
-collect.global_variables \
-collect.info_schema.clientstats \
-collect.info_schema.innodb_metrics \
-collect.info_schema.processlist \
-collect.info_schema.tables.databases \
-collect.info_schema.tablestats \
-collect.slave_status \
-collect.binlog_size \
-collect.perf_schema.tableiowaits \
-collect.perf_schema.indexiowaits \
-collect.perf_schema.tablelocks'
```

```ruby
mysqld_exporter 'main' do
  data_source_name '/'
  config_my_cnf '~/.my/cnf'
  user 'mysql'
end
```

## node_exporter

* `collector_diskstats_ignored_devices` Regexp of devices to ignore for diskstats. (default: "^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$")
* `collector_filesystem_ignored_fs_types` Regexp of filesystem types to ignore for filesystem collector. (default: "^(sys|proc|auto)fs$")
* `collector_filesystem_ignored_mount_points` Regexp of mount points to ignore for filesystem collector. (default: "^/(sys|proc|dev)($|/)")
* `collector_netclass_ignored_devices` Regexp of net devices to blacklist (mutually exclusive to device-whitelist) (default: "^$")
* `collector_netdev_device_blacklist` Regexp of net devices to ignore for netdev collector. (default: "^$")
* `collector_netdev_device_whitelist` Regexp of net devices to whitelist (mutually exclusive to device-blacklist) (default: "^$")
* `collector_ntp_ip_ttl` IP TTL to use while sending NTP query. (default: "1")
* `collector_ntp_local_offset_tolerance` Offset between local clock and local ntpd time to tolerate. (default: "1ms")
* `collector_ntp_max_distance` Max accumulated distance to the root. (default: "3.46608s")
* `collector_ntp_protocol_version` NTP protocol version. (default: "4")
* `collector_ntp_server_is_local` Certify that collector.ntp.server address is the same local host as this collector.
* `collector_ntp_server` NTP server to use for ntp collector. (default: "127.0.0.1")
* `collector_qdisc_fixtures` Test fixtures to use for qdisc collector end-to-end testing.
* `collector_perf_cpus` specify a list of alternate CPUs.
* `collector_runit_servicedir` Path to runit service directory.
* `collector_supervisord_url` XML RPC endpoint. (default: "http://localhost:9001/RPC2")
* `collector_systemd_enable_restarts_metrics` Enables service unit metric service\_restart\_total
* `collector_systemd_enable_start_time_metrics` Enables service unit metric unit\_start\_time\_seconds
* `collector_systemd_enable_task_metrics` Enables service unit tasks metrics unit\_tasks\_current and unit\_tasks\_max
* `collector_systemd_private` Establish a private, direct connection to systemd without dbus.
* `collector_systemd_unit_blacklist` Regexp of systemd units to blacklist. Units must both match whitelist and not match blacklist to be included. (default: ".+\\.(automount|device|mount|scope|slice)")
* `collector_systemd_unit_whitelist` Regexp of systemd units to whitelist. Units must both match whitelist and not match blacklist to be included. (defaut: ".+")
* `collector_textfile_directory` Directory to read text files with metrics from. (default: "")
* `collector_vmstat_fields` Regexp of fields to return for vmstat collector. (default: "^(oom\_kill|pgpg|pswp|pg.*fault).*")
* `collector_wifi_fixtures` Test fixtures to use for wifi collector metrics.
* `collectors_disabled` An array of explicitly disabled collectors.
* `collectors_enabled` An array of explicitly enabled collectors.
* `custom_options` Use for your configuration if defined proterties are not satisfying your needs.
* `log_format` Where to send log files. (default: "logger:stdout")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]
* `path_procfs` procfs mountpoint. (default: "/proc")
* `path_rootfs` rootfs mountpoint. (default: "/")
* `path_sysfs` sysfs mountpoint. (default: "/sys")
* `user` System user to run node exporter as. (default "root") **change this to a non-root user if possible**
* `web_disable_exporter_metrics` Exclude metrics about the exporter itself. (promhttp_*, process_*, go_*)
* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9100")
* `web_max_requests` Maximum number of parallel scrape requests. Use 0 to disable. (default: "40")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

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
* `node['prometheus_exporters']['node']['user']`

and add `recipe['prometheus_exporters::node]` to your run_list.

## postgres_exporter

The postgres_exporter resource supports running multiple copies of PostgreSQL exporter the same system. This is useful if you have multiple copies of PostgreSQL running on the same system
(eg. different versions) or you are connecting to multiple remote PostgreSQL servers across the network.

* `constant_labels` A list of label=value separated by comma(,).
* `data_source_name` PostgreSQL connection string. E.g. `postgresql://login:password@hostname:port/dbname`
* `data_source_pass_file` The same as above but reads the password from a file.
* `data_source_pass` When using `data_source_uri`, this option is used to specify the password to connect with.
* `data_source_uri` An alternative to `data_source_name` which exclusively accepts the raw URI without a username and password component.
* `data_source_user_file` The same, but reads the username from a file.
* `data_source_user` When using `data_source_uri`, this option is used to specify the username.
* `disable_default_metrics` Use only metrics supplied from `queries.yaml` via `--extend.query-path`.
* `extend_query_path` Path to a YAML file containing custom queries to run.
* `instance_name` name of PostgreSQL exporter instance. (**name attribute**)
* `log_format` If set use a syslog logger or JSON logging. Example: logger:syslog?appname=bob&local=7 or logger:stdout?json=true. Defaults to stderr.
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal].
* `user` System user to run exporter as. (default "postgres")
* `web_listen_address` Address to listen on for web interface and telemetry. (default "127.0.0.1:9187")
* `web_telemetry_path` Path under which to expose metrics. (default "/metrics")

```ruby

postgres_exporter '9.5_main' do
  data_source_name 'postgresql://localhost:5432/example'
  user 'postgres'
end
```

## process_exporter

Monitor resource usage of processes or process groups. Read more [here](https://github.com/ncabatoff/process-exporter).

* `children` If a proc is tracked, track with it any children that aren't part of their own group (default: true)
* `config_path` Optional config file for configuring which processes to monitor. The example below monitors all processes on the system. Alternately specific process names and groups may be specified using the `proc_names` and `name_mapping` properties
* `custom_options` Use for your configuration if defined properties are not satisfying your needs.
* `debug` Print debug information to the log. default: false
* `namemapping` Comma-separated list of alternating `name,regexp` values. It allows assigning a name to a process based on a combination of the process name and command line
* `procfs` procfs mountpoint. Default: "/proc"
* `procnames` Comma separated list of process names to monitor
* `recheck` On each scrape the process names are re-evaluated. This is disabled by default as an optimization, but since processes can choose to change their names, this may result in a process falling into the wrong group if we happen to see it for the first time before it's assumed its proper name. Default: false
* `threads` report on per-threadname metrics as well
* `user` User under whom to start process exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. Default: ":9256"
* `web_telemetry_path` Path for the metrics endpoint. Default: '/metrics'

```ruby
process_exporter 'main' do
  config_path "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/all.yml"

  action %i[install enable]
end

file "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/all.yml" do
  content <<HERE
    process_names:
    - name: "{{.comm}}"
      cmdline:
      - '.+'
here
  notifies :start, 'process_exporter[main]'
end
```

## rabbitmq_exporter

* `cafile` Path to root certificate for access management plugin. Just needed if self signed certificate is used. Will be ignored if the file does not exist
* `certfile` Path to client certificate used to verify the exporter's authenticity. Will be ignored if the file does not exist
* `exclude_metrics` Metric names to exclude from export. Comma-seperated string or an array. e.g. "recv_oct,recv_cnt". See exporter_*.go for names
* `include_queues` Regex queue filter. Just matching names are exported
* `include_vhost` Regex vhost filter. Only queues in matching vhosts are exported
* `keyfile` Path to private key used with certificate to verify the exporter's authenticity. Will be ignored if the file does not exist
* `log_level` Log level. Possible values: "debug", "info", "warning", "error", "fatal", or "panic"
* `max_queues` Max number of queues before we drop metrics (disabled if set to 0)
* `output_format` Log ouput format. TTY and JSON are suported
* `publish_addr` Listening host/IP for the exporter
* `publish_port` Listening port for the exporter
* `rabbit_capabilities` Comma-separated list or an array of extended scraping capabilities supported by the target RabbitMQ server
* `rabbit_exporters` List of enabled modules. "connections" and shovel are disabled by default
* `rabbit_password` Password for rabbitMQ management plugin
* `rabbit_timeout` Timeout in seconds for retrieving data from management plugin
* `rabbit_url` Url to rabbitMQ management plugin (must start with http(s)://)
* `rabbit_user` Username for rabbitMQ management plugin. User needs monitoring tag!
* `skip_queues` Regex, matching queue names are not exported (useful for short-lived rpc queues). First performed INCLUDE, after SKIP
* `skip_vhost` Regex, matching vhost names are not exported. First performs INCLUDE_VHOST, then SKIP_VHOST
* `skiverify` Will ignore certificate errors of the management plugin if true (default: "false")
* `user` User under whom to start rabbitmq exporter. (default: "root")

```ruby

rabbitmq_exporter 'main' do
  rabbit_user 'Roger'
  rabbit_exporters %w[exchange node]
end
```

## redis_exporter

*Important:* For redis exporter version equal or lower than `0.34.1` use version `0.13.1` of this cookbook.

* `check_keys` Comma separated list of keys to export value and length/size, eg: `db3=user_count` will export key `user_count` from db `3`. db defaults to `0` if omitted. (default: "")
* `check_single_keys` Comma separated list of single keys to export value and length/size.
* `config_command` What to use for the CONFIG command (default: "CONFIG")
* `connection_timeout` Timeout for connection to Redis instance (default: "15s")
* `debug` Enable or disable debug output. (default: false)
* `include_system_metrics` Whether to include system metrics like e.g. redis\_total\_system\_memory\_bytes
* `is_tile38` Whether to scrape Tile38 specific metrics.
* `log_format` In what format should logs be shown. (default: "txt")
* `namespace` Namespace for the metrics. (default: "redis")
* `redis_addr` Address of one or more redis nodes, comma separated. (default: "redis://localhost:6379")
* `redis_only_metrics` Whether to export go runtime metrics also.
* `redis_password` Password to use when authenticating to Redis. (default: "")
* `script` Path to Lua Redis script for collecting extra metrics.
* `skip_tls_versification` Whether to to skip TLS verification.
* `user` User under whom to start redis exporter. (default: "root")
* `web_listen_address` address to listen on for web interface and telemetry. (default: "0.0.0.0:9121")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

```ruby
redis_exporter 'main' do
  redis_addr 'redis://db01.example.com:6379,redis://10.0.0.1:6379'
  redis_password 'password_one,password_two'
  redis_alias 'example_production,example_staging'
end
```

## snmp_exporter

This exporter needs a custom generated config file. Read more [here](https://github.com/prometheus/snmp_exporter#configuration) and [here](https://github.com/prometheus/snmp_exporter/tree/master/generator). For test purposes and the most basic usage you can grab a default `snmp.yml` which is located here: `/opt/snmp_exporter-PASTE_CURRENT_VERSION.linux-amd64/snmp.yml`

* `config_file` default: '/etc/snmp_exporter/snmp.yaml'
* `custom_options` Any other raw options for your configuration if defined proterties are not satisfying your needs.
* `log_format` Where to send log files. (default: "logger:stdout")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]
* `snmp_wrap_large_counters` Wrap 64-bit counters to avoid floating point rounding.
* `user` User under whom to start snmp exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9116")

```ruby
snmp_exporter 'main' do
  config_file "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp.yml"
end
```

## statsd_exporter

Monitor statsd metrics and stats. Read more [here](https://github.com/prometheus/statsd_exporter).

* `log_format` Where to send log files. (default: "logger:stdout")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]. (default: "info")
* `statsd_listen_mapping_config` Metric mapping configuration file name
* `statsd_listen_read_buffer` Size (in bytes) of the operating system's transmit read buffer associated with the UDP or Unixgram connection
* `statsd_listen_tcp` TCP address on which to receive statsd metric lines
* `statsd_listen_udp` UDP address on which to receive statsd metric lines
* `statsd_listen_unixgram_mode` Unixgram socket permission mode
* `statsd_listen_unixgram` Unixgram socket path on which to receive statsd metric lines
* `user` User under whom to start the exporter. (default: "root")
* `web_listen_address` Address to listen on for web interface and telemetry. (default: "0.0.0.0:9102")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")

```ruby
statsd_exporter 'main' do
  statsd_listen_udp "9125"
  user 'statsd'
end
```

Use the given defaults or set the attributes...

* `node['prometheus_exporters']['listen_interface']`
* `node['prometheus_exporters']['statsd']['port']`
* `node['prometheus_exporters']['statsd']['listen_udp']`
* `node['prometheus_exporters']['statsd']['listen_tcp']`
* `node['prometheus_exporters']['statsd']['listen_unixgram']`
* `node['prometheus_exporters']['statsd']['listen_unixgram_mode']`
* `node['prometheus_exporters']['statsd']['mapping_config']`
* `node['prometheus_exporters']['statsd']['read_buffer']`
* `node['prometheus_exporters']['statsd']['user']`

and add `recipe['prometheus_exporters::statsd]` to your run_list.


## varnish_exporter

* `docker_container_name` Docker container name to exec varnishstat in.
* `exit_on_errors` Exit process on scrape errors. (default: "false")
* `n` varnishstat -n value.
* `N` varnishstat -N value.
* `user` User under whom to start varnish exporter. (default: "root")
* `varnishstat_path` Path to varnishstat. (default: "varnishstat")
* `verbose` Verbose logging. (default: "false")
* `web_listen_address` Address on which to expose metrics. (default: ":9131")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")
* `with_go_metrics` Export go runtime and http handler metrics. (default: "false")

```ruby
varnish_exporter 'main' do
  varnishstat_path "/my/own/varnishstat"
  web_listen_address "1.2.3.4:9132"
  web_telemetry_path "/_metrics"
  user "my_user"
end
```

Use the given defaults or set the attributes...

* `node['prometheus_exporters']['listen_interface']`
* `node['prometheus_exporters']['varnish']['varnishstat_path']`
* `node['prometheus_exporters']['varnish']['telemetry_path']`
* `node['prometheus_exporters']['varnish']['N']`
* `node['prometheus_exporters']['varnish']['docker_container_name']`
* `node['prometheus_exporters']['varnish']['exit_on_errors']`
* `node['prometheus_exporters']['varnish']['n']`
* `node['prometheus_exporters']['varnish']['verbose']`
* `node['prometheus_exporters']['varnish']['with_go_metrics']`
* `node['prometheus_exporters']['varnish']['user']`

and add `recipe['prometheus_exporters::varnish]` to your run_list.

## wmi_exporter

Expects the Chocolatey package manager to already be installed.  This is up to individuals to provide by including the [Chocolatey cookbook](https://github.com/chocolatey/chocolatey-cookbook) in their own wrapper cookbooks.

* `enabled_collectors`, String, default: 'cpu,cs,logical\_disk,net,os,service,system'
* `listen_address`, String, default: '0.0.0.0'
* `listen_port`, String, default: '9182'
* `metrics_path`, Strin, default: '/metrics'
* `version`, String, default: '0.2.7'

Use the given defaults or set the attributes...

* `node['prometheus_exporters']['wmi']['version']['listen_interface']`
* `node['prometheus_exporters']['wmi']['listen_address']`
* `node['prometheus_exporters']['wmi']['listen_port']`
* `node['prometheus_exporters']['wmi']['metrics_path']`

and add `recipe['prometheus_exporters::wmi]` to your run_list.

## nginx_exporter

* `nginx_retries`, String, default: 5
* `nginx_retry_interval`, String, default: 5s
* `nginx_scrape_uri`, String, default: 'http://127.0.0.1:83/nginx_status'
* `nginx_ssl_ca_cert`, String
* `nginx_ssl_client_cert`, String
* `nginx_ssl_client_key`, String
* `nginx_ssl_verify`, [true, false], default: false
* `nginx_timeout`, String, default: 5s
* `prometheus_const_labels`, String, default: ""
* `web_listen_address`, String, default: ':9113'
* `web_telemetry_path`, String, default: '/metrics'

```ruby
  nginx_exporter 'main' do
    action %i(install enable start)
  end
```
# Discovery

Each exporter will set an attribute when it's enabled, in the form of `node['prometheus_exporters'][exporter_name]['enabled']`. This makes it possible to search for
exporters within your environment using knife search or from within other cookbooks using a query such as:

```knife search node 'prometheus_exporters_node_enabled:true'```

This query will return all nodes with configured node exporters which can be used for automatically configuring Prometheus servers.

# Known Issues

* The snmp_exporter requires a configuration file that is usually created by a config generator. Currently this functionality must be provided by a wrapper cookbook.
