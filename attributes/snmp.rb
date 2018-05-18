default['prometheus_exporters']['snmp']['version'] = '0.10.0'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = '1b1ee99fa4ce1fe0ae66382af926c3038419c9d3b6dd8150bd1c9d589c804470'
