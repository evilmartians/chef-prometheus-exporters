default['prometheus_exporters']['postgres']['version'] = 'v0.4.2'
default['prometheus_exporters']['postgres']['url'] = "https://github.com/wrouesnel/postgres_exporter/releases/download/#{node['prometheus_exporters']['postgres']['version']}/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64.tar.gz"
default['prometheus_exporters']['postgres']['checksum'] = '630c718530faf61620d80ab701c25f8277be6842cc099d27208fbe5471407562'
