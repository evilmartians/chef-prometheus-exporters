default['prometheus_exporters']['snmp']['version'] = '0.4.0'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = '49c93ffb0385894aed2e1d7a20758191f3ba76bfc1c46bc46adab3637303053e'
