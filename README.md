# prometheus_exporters

Pretty straightforward cookbook to install and configure some node exporters for Prometheus installation.

I've decided I want them to be available via chef custom resources (who knows where I would like to invoke them from) and all in one place.

Yes, It's a bit messy, but works fine.

Help us to clean up a bit if you have some spare time.

P.S. It's an early release so do not expect much for at least a few weeks. :)

# Supports

Ubuntu 14 & 16
CentOS 7 (probably any RHEL 7+ based)

# Resources

## node_exporter

* `web_listen_address`, String, default: ':9100'
* `web_telemetry_path`, String, default: '/metrics'
* `log_level`, String, default: 'info'
* `log_format`, String, default: 'logger:stdout'
* `collectors_enabled`, Array
* `collector_textfile_directory`, String
* `collector_netdev_ignored_devices`, String
* `collector_diskstats_ignored_devices`, String
* `collector_filesystem_ignored_fs_types`, String
* `collector_filesystem_ignored_mount_point`, String
* `custom_options`, String

Use `custom_options` for your configuration if defined proterties are not satisfying your needs.

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

# Known Issues

* The snmp_exporter requires a configuration file that is usually created by a config generator. Currently this functionality must be provided by a wrapper cookbook.
* If any of the exporters are ran as a non-root user on a system with Sys V init, then it will not be able to write to its logfile
