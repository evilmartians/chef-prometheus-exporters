default['prometheus_exporters']['postgres']['version'] = 'v0.5.1'
default['prometheus_exporters']['postgres']['url'] = "https://github.com/wrouesnel/postgres_exporter/releases/download/#{node['prometheus_exporters']['postgres']['version']}/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64.tar.gz"
default['prometheus_exporters']['postgres']['checksum'] = '7b00cc56d83e3a8f5a58d2b0f17f12b1b3b1b1ecccffffc3e8446ff187058c0e'
