default['prometheus_exporters']['redis']['version'] = '1.1.1'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = '2a8b4ebcfd6bb5132f01046ff39de86a955cdb04bf07ba929cff2565bcedbd9c'
