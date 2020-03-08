default['prometheus_exporters']['mongodb']['version'] = '0.10.0'
default['prometheus_exporters']['mongodb']['url'] = "https://github.com/percona/mongodb_exporter/releases/download/v#{node['prometheus_exporters']['mongodb']['version']}/mongodb_exporter-#{node['prometheus_exporters']['mongodb']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['mongodb']['checksum'] = 'acfbd42731d5094e43b5bbc6a4fe679345d9b6160f884868491a06f090515b22'
