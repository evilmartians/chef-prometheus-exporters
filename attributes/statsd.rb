default['prometheus_exporters']['statsd']['version'] = '0.12.2'
default['prometheus_exporters']['statsd']['url'] = "https://github.com/prometheus/statsd_exporter/releases/download/v#{node['prometheus_exporters']['statsd']['version']}/statsd_exporter-#{node['prometheus_exporters']['statsd']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['statsd']['checksum'] = '9976810ae7a0e3593d6727d46d8c45a23f534e5794de816ed8309a42bb86cb34'

default['prometheus_exporters']['statsd']['port'] = 9102
default['prometheus_exporters']['statsd']['user'] = 'root'
