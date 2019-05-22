default['prometheus_exporters']['redis']['version'] = '0.34.1'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = '2a6be17b28e76a7e9aff5b87c4325cec526e0f871e067234f0c1abfdce97ac60'
