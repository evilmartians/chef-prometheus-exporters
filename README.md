# prometheus_exporters

Cookbook to install and configure various Prometheus exporters on systems to be monitored by Prometheus.

Currently supported exporters are node, postgres, redis, mysqld, haproxy, process, blackbox, snmp, and wmi. More may be added in the future. Please contact the author if you have specific requests.

All of the exporters are available as chef custom resources that can be instantiated from other cookbooks.


# Supports

* Ubuntu 14.04
* Ubuntu 16.04
* Ubuntu 18.04
* Debian 8
* Debian 9
* CentOS 6
* CentOS 7

And probably other RHEL or Debian based distributions.

* Windows Server 2012 & 2016 (wmi_exporter recipe only)

Tests are made using last available Chef 14 along with latest Chef 13.

# Resource List

- [blackbox_exporter](https://github.com/evilmartians/chef-prometheus-exporters#blackbox_exporter)
- [node_exporter](https://github.com/evilmartians/chef-prometheus-exporters#node_exporter)
- [mysqld_exporter](https://github.com/evilmartians/chef-prometheus-exporters#mysqld_exporter)
- [postgres_exporter](https://github.com/evilmartians/chef-prometheus-exporters#postgres_exporter)
- [process_exporter](https://github.com/evilmartians/chef-prometheus-exporters#process_exporter)
- [redis_exporter](https://github.com/evilmartians/chef-prometheus-exporters#redis_exporter)
- [snmp_exporter](https://github.com/evilmartians/chef-prometheus-exporters#snmp_exporter)
- [wmi_exporter](https://github.com/evilmartians/chef-prometheus-exporters#wmi_exporter)
- [haproxy_exporter](https://github.com/evilmartians/chef-prometheus-exporters#haproxy_exporter)


# Resources

## blackbox_exporter

This exporter requires a config file. Read more [here](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md). For basic usage the default `blackbox.yml` should be sufficient.

* `web_listen_address` Address to listen on for web interface and telemetry. (default: ":9115")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error]
* `config_file` default: `/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml`
* `timeout_offset` default: 0.5 Offset to subtract from timeout in seconds.

```ruby
blackbox_exporter 'main'
```

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

## mysqld_exporter

The mysqld_exporter resource supports running multiple copies of the MySQL exporter on the same system.

* `instance_name` name of MySQL exporter instance. (**name attribute**)
* `data_source_name` MySQL connection string
* `config_my_cnf` Path to .my.cnf file to read MySQL credentials from. (default: ~/.my.cnf)
* `log_format` If set use a syslog logger or JSON logging. Example: logger:syslog?appname=bob&local=7 or logger:stdout?json=true. Defaults to stderr.
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal].
* `web_listen_address` Address to listen on for web interface and telemetry. (default "127.0.0.1:9104")
* `web_telemetry_path` Path under which to expose metrics. (default "/metrics")
* `user` System user to run exporter as. (default "mysql")
* `collector_flags` Specify which collector flags you wish to use.

(default)
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

## process_exporter

Monitor resource usage of processes or process groups. Read more [here](https://github.com/ncabatoff/process-exporter).

* `web_listen_address` Address to listen on for web interface and telemetry. Default: ":9256"
* `web_telemetry_path` Path for the metrics endpoint. Default: '/metrics'
* `config_file` Optional config file for configuring which processes to monitor. The example below monitors all processes on the system. Alternately specific process names and groups may be specified using the `proc_names` and `name_mapping` properties
* `proc_names` Comma separated list of process names to monitor
* `name_mapping` Comma-separated list of alternating `name,regexp` values. It allows assigning a name to a process based on a combination of the process name and command line
* `path_procfs` procfs mountpoint. Default: "/proc"
* `children` If set, any process that otherwise isn't part of its own group becomes part of the first group found (if any) when walking the process tree upwards. In other words, resource usage of subprocesses is added to their parent's usage unless the subprocess identifies as a different group name. Default: true
* `recheck` On each scrape the process names are re-evaluated. This is disabled by default as an optimization, but since processes can choose to change their names, this may result in a process falling into the wrong group if we happen to see it for the first time before it's assumed its proper name. Default: false
* `debug` Print debug information to the log. default: false
* `custom_options` Use for your configuration if defined properties are not satisfying your needs.

```ruby
process_exporter 'main' do
  config_file "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/all.yml"

  action %i[install enable]
end

file "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/all.yml" do
  content <<HERE
    process_names:
    - name: "{{.Comm}}"
      cmdline:
      - '.+'
HERE
  notifies :start, 'process_exporter[main]'
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

## wmi_exporter

Expects the Chocolatey package manager to already be installed.  This is up to individuals to provide by including the [Chocolatey cookbook](https://github.com/chocolatey/chocolatey-cookbook) in their own wrapper cookbooks.

* `version`, String, default: '0.2.7'
* `enabled_collectors`, String, default: 'cpu,cs,logical_disk,net,os,service,system'
* `listen_address`, String, default: '0.0.0.0'
* `listen_port`, String, default: '9182'
* `metrics_path`, Strin, default: '/metrics'

Use the given defaults or set the attributes...

* `node['prometheus_exporters']['wmi']['version']['listen_interface']`
* `node['prometheus_exporters']['wmi']['listen_address']`
* `node['prometheus_exporters']['wmi']['listen_port']`
* `node['prometheus_exporters']['wmi']['metrics_path']`

and add `recipe['prometheus_exporters::wmi]` to your run_list.

## haproxy_exporter

Monitor HAProxy metrics and stats. Read more [here](https://github.com/prometheus/haproxy_exporter).

* `web_listen_address` Address to listen on for web interface and telemetry. (default: "0.0.0.0:9116")
* `web_telemetry_path` Path under which to expose metrics. (default: "/metrics")
* `log_level` Only log messages with the given severity or above. Valid levels: [debug, info, warn, error, fatal]. (default: "info")
* `log_format` Where to send log files. (default: "logger:stdout")
* `haproxy_scrape_uri` URI on which to scrape HAProxy.
* `haproxy_ssl_verify` Flag that enables SSL certificate verification for the scrape URI.
* `haproxy_server_metric_fields` Comma-separated list of exported server metrics.
* `haproxy_timeout` Timeout for trying to get stats from HAProxy.
* `haproxy_pid_file` Path to HAProxy pid file.
* `user` User under whom to start redis exporter. (default: "root")

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

# Discovery

Each exporter will set an attribute when it's enabled, in the form of `node['prometheus_exporters'][exporter_name]['enabled']`. This makes it possible to search for
exporters within your environment using knife search or from within other cookbooks using a query such as:

```knife search node 'prometheus_exporters_node_enabled:true'```

This query will return all nodes with configured node exporters which can be used for automatically configuring Prometheus servers.

# Known Issues

* The snmp_exporter requires a configuration file that is usually created by a config generator. Currently this functionality must be provided by a wrapper cookbook.
