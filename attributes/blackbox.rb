default['prometheus_exporters']['blackbox']['version'] = '0.16.0'
default['prometheus_exporters']['blackbox']['url'] = "https://github.com/prometheus/blackbox_exporter/releases/download/v#{node['prometheus_exporters']['blackbox']['version']}/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['blackbox']['checksum'] = '52d3444a518ea01f220e08eaa53eb717ef54da6724760c925ab41285d0d5a7bd'
default['prometheus_exporters']['blackbox']['timeout_offset'] = '0.5'
default['prometheus_exporters']['blackbox']['log_level'] = 'info'
default['prometheus_exporters']['blackbox']['user'] = 'root'
