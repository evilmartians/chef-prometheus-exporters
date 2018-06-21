default['prometheus_exporters']['redis']['version'] = '0.18.0'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = '394aea00be7dc84682edc6d06128db68db43ab79ca1f5feacd8c42ed79d83246'
