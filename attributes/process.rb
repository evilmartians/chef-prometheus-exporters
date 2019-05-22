default['prometheus_exporters']['process']['version'] = '0.5.0'
default['prometheus_exporters']['process']['url'] = "https://github.com/ncabatoff/process-exporter/releases/download/v#{node['prometheus_exporters']['process']['version']}/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['process']['checksum'] = '1b422f5f26ebefc0928b56fbefc08d0aab3cc7a636627d7d57b200af84e91bb9'
