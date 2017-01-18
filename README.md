# prometheus_exporters

Pretty straightforward cookbook to install and configure some node exporters for Prometheus installation.

I've decided I want them to be available via chef custom resources (who knows where I would like to invoke them from) and all in one place.

Yes, It's a bit messy, but works fine.

Help us to clean up a bit if you have some spare time.

P.S. It's an eary release so do not expect much for at least a few weeks. :)

# Supports

Only Ubuntu 14 & 16 for now.

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