default['prometheus_exporters']['redis']['version'] = '0.14'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = 'ba80d6902a7020ca94156741cb1d6e44480d19bfa753315d5e6b0f099921bce0'
