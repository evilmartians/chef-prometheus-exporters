default['prometheus_exporters']['redis']['version'] = '0.22.1'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = '2f841f5446a15ff0303013033a0e9813764713867d85b588f3feb346f8258e83'
