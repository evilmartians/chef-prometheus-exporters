default['prometheus_exporters']['redis']['version'] = '1.3.5'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = 'bb408128cb4c3024c8532dae3539080349687cc96cbab51a1e06e9a15519b874'
