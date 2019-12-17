default['prometheus_exporters']['postgres']['version'] = 'v0.8.0'
default['prometheus_exporters']['postgres']['url'] = "https://github.com/wrouesnel/postgres_exporter/releases/download/#{node['prometheus_exporters']['postgres']['version']}/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64.tar.gz"
default['prometheus_exporters']['postgres']['checksum'] = '272ed14d3c360579d6e231db34a568ec08f61d2e163cf111e713929ffb6db3f5'
