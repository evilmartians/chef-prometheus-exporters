default['prometheus_exporters']['snmp']['version'] = '0.15.0'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = 'c5e8e58a8187e9d0bd41dbeb7e09a15f5a59626821fa801dd99828d9cdd7efe9'
