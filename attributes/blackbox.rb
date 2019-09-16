default['prometheus_exporters']['blackbox']['version'] = '0.15.0'
default['prometheus_exporters']['blackbox']['url'] = "https://github.com/prometheus/blackbox_exporter/releases/download/v#{node['prometheus_exporters']['blackbox']['version']}/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['blackbox']['checksum'] = '3bdd8d94776a0bb747920d7aae6992918c5a7afa5aafb2e187362fea51e02257'
default['prometheus_exporters']['blackbox']['timeout_offset'] = '0.5'
default['prometheus_exporters']['blackbox']['log_level'] = 'info'
default['prometheus_exporters']['blackbox']['user'] = 'root'
