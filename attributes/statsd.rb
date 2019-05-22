default['prometheus_exporters']['statsd']['version'] = '0.10.4'
default['prometheus_exporters']['statsd']['url'] = "https://github.com/prometheus/statsd_exporter/releases/download/v#{node['prometheus_exporters']['statsd']['version']}/statsd_exporter-#{node['prometheus_exporters']['statsd']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['statsd']['checksum'] = 'a2ff6d60a09eac103371d59caf849f62e2323df29868ee9a4c254d76551b2cef'

default['prometheus_exporters']['statsd']['port'] = 9102
default['prometheus_exporters']['statsd']['user'] = 'root'
