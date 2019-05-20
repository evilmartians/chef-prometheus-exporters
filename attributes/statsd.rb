default['prometheus_exporters']['statsd']['version'] = '0.10.3'
default['prometheus_exporters']['statsd']['url'] = "https://github.com/prometheus/statsd_exporter/releases/download/v#{node['prometheus_exporters']['statsd']['version']}/statsd_exporter-#{node['prometheus_exporters']['statsd']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['statsd']['checksum'] = 'e0c237f22693690025d52ee2beac25ca4d7bd0c953ff9e785b6e2c685d5f78d0'

default['prometheus_exporters']['statsd']['port'] = 9102
default['prometheus_exporters']['statsd']['user'] = 'root'
