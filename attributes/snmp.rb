default['prometheus_exporters']['snmp']['version'] = '0.18.0'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = '11381ea4671e18f31a0c72a23c9383aa68948d4f7147f9b51693f6229383f749'
default['prometheus_exporters']['snmp']['user'] = 'root'
