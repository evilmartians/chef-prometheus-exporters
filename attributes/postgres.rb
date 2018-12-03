default['prometheus_exporters']['postgres']['version'] = 'v0.4.7'
default['prometheus_exporters']['postgres']['url'] = "https://github.com/wrouesnel/postgres_exporter/releases/download/#{node['prometheus_exporters']['postgres']['version']}/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64.tar.gz"
default['prometheus_exporters']['postgres']['checksum'] = 'c34d61bb4deba8efae06fd3c9979b96dae3f3c757698ce3384c80fff586c667b'
