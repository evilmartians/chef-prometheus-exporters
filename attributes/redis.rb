default['prometheus_exporters']['redis']['version'] = '1.17.1'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = 'd424d0524867a1fc503e7335f0856d72f125a4331b759bc3c61cdcbbb80ae50e'
