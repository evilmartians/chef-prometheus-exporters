default['prometheus_exporters']['postgres']['version'] = '0.4.1'
default['prometheus_exporters']['postgres']['url'] = "https://github.com/wrouesnel/postgres_exporter/releases/download/v#{node['prometheus_exporters']['postgres']['version']}/postgres_exporter_v#{node['prometheus_exporters']['postgres']['version']}_linux-amd64.tar.gz"
default['prometheus_exporters']['postgres']['checksum'] = '219c2c116cb496d54ddbd23f392a38c3496ab8e7118dfbf8b7c0b21593dedbfd'
