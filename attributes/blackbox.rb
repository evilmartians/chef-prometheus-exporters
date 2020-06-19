default['prometheus_exporters']['blackbox']['version'] = '0.17.0'
default['prometheus_exporters']['blackbox']['url'] = "https://github.com/prometheus/blackbox_exporter/releases/download/v#{node['prometheus_exporters']['blackbox']['version']}/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['blackbox']['checksum'] = '6ebe26d1e97d26ee08d0cd6d37a34f2f67c8414ea5e40407eadc0ac950ed518e'
default['prometheus_exporters']['blackbox']['timeout_offset'] = '0.5'
default['prometheus_exporters']['blackbox']['log_level'] = 'info'
default['prometheus_exporters']['blackbox']['user'] = 'root'
