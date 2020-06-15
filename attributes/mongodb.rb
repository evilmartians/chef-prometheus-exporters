default['prometheus_exporters']['mongodb']['version'] = '0.11.0'
default['prometheus_exporters']['mongodb']['url'] = "https://github.com/percona/mongodb_exporter/releases/download/v#{node['prometheus_exporters']['mongodb']['version']}/mongodb_exporter-#{node['prometheus_exporters']['mongodb']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['mongodb']['checksum'] = 'e0be8af72dd89a9637cbeedfa637694607209edbca4dafcdb11e22bcda270b6e'
