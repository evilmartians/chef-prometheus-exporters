default['prometheus_exporters']['snmp']['version'] = '0.13.0'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = 'a6c0795109e55c422ec20ee88aa0e966acbe0a6ad1f2642180375a092ed7b3b1'
