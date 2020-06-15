default['prometheus_exporters']['redis']['version'] = '1.6.1'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = '9e0e75bdf246a13807d1a205075a711721a7b065dd32e921b5f55536dbc63600'
