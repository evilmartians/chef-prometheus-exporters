default['prometheus_exporters']['snmp']['version'] = '0.16.1'
default['prometheus_exporters']['snmp']['url'] = "https://github.com/prometheus/snmp_exporter/releases/download/v#{node['prometheus_exporters']['snmp']['version']}/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['snmp']['checksum'] = '7de711be5f73f2fe11b450bd8caade9e20aa802a0c64a73651035065bf049ef5'
default['prometheus_exporters']['snmp']['user'] = 'root'
