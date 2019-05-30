default['prometheus_exporters']['redis']['version'] = '1.0.0'
default['prometheus_exporters']['redis']['url'] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = 'cbfd34b209e139c6d563e0fb1b0c02778e2a0578d21237f9f044eeba005ba51d'
