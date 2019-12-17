default['prometheus_exporters']['statsd']['version'] = '0.13.0'
default['prometheus_exporters']['statsd']['url'] = "https://github.com/prometheus/statsd_exporter/releases/download/v#{node['prometheus_exporters']['statsd']['version']}/statsd_exporter-#{node['prometheus_exporters']['statsd']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['statsd']['checksum'] = '4685fcefa770b5643a58687e9fc3b311716ae915136dda8cc5c9b5a4fbe0e964'

default['prometheus_exporters']['statsd']['port'] = 9102
default['prometheus_exporters']['statsd']['user'] = 'root'
