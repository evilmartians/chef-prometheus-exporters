default['prometheus_exporters']['process']['version'] = '0.6.0'
default['prometheus_exporters']['process']['url'] = "https://github.com/ncabatoff/process-exporter/releases/download/v#{node['prometheus_exporters']['process']['version']}/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['process']['checksum'] = 'ae0aea4a8ebd7baa0ae434be555a7e0672235b175725f4f6ff8f029136c95f73'
default['prometheus_exporters']['process']['user'] = 'root'
