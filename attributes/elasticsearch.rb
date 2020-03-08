default['prometheus_exporters']['elasticsearch']['version'] = '1.1.0'
default['prometheus_exporters']['elasticsearch']['url'] = "https://github.com/justwatchcom/elasticsearch_exporter/releases/download/v#{node['prometheus_exporters']['elasticsearch']['version']}/elasticsearch_exporter-#{node['prometheus_exporters']['elasticsearch']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['elasticsearch']['checksum'] = '1d2444d7cbf321cb31d58d2fecc08c8bc90bbcec581f8a1ddb987f9ef425482b'
