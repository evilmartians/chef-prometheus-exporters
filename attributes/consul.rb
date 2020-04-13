default['prometheus_exporters']['consul']['version'] = '0.6.0'
default['prometheus_exporters']['consul']['url'] = "https://github.com/prometheus/consul_exporter/releases/download/v#{node['prometheus_exporters']['consul']['version']}/consul_exporter-#{node['prometheus_exporters']['consul']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['consul']['checksum'] = '70770e54cfdd0997f3031357ce0f45bbe16e7d1b44fc3a0771b192c5bfe1af10'
