default['prometheus_exporters']['snmp']['version'] = '0.8.0'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = '62871482b90f6ee91a28a68e469e2acb5c56b98dda5673d39331a2e38fa1b9a9'
