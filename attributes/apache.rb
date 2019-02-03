default['prometheus_exporters']['apache']['version'] = '0.5.0'
default['prometheus_exporters']['apache']['url'] = "https://github.com/Lusitaniae/apache_exporter/releases/download/v#{node['prometheus_exporters']['apache']['version']}/apache_exporter-#{node['prometheus_exporters']['apache']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['apache']['checksum'] = '60dc120e0c5d9325beaec4289d719e3b05179531f470f87d610dc2870c118144'
