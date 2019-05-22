default['prometheus_exporters']['blackbox']['version'] = '0.14.0'
default['prometheus_exporters']['blackbox']['url'] = "https://github.com/prometheus/blackbox_exporter/releases/download/v#{node['prometheus_exporters']['blackbox']['version']}/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['blackbox']['checksum'] = 'a2918a059023045cafb911272c88a9eb83cdac9a8a5e8e74844b5d6d27f19117'
default['prometheus_exporters']['blackbox']['timeout_offset'] = '0.5'
default['prometheus_exporters']['blackbox']['log_level'] = 'info'
