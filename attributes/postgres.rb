default['prometheus_exporters']['postgres']['version'] = 'v0.4.6'
default['prometheus_exporters']['postgres']['url'] = "https://github.com/wrouesnel/postgres_exporter/releases/download/#{node['prometheus_exporters']['postgres']['version']}/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64.tar.gz"
default['prometheus_exporters']['postgres']['checksum'] = '9ed457c9a6d3a1e0132b3fe10f1d072457a667b009993a73e90b47ca99cc5bca'
