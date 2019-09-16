default['prometheus_exporters']['mysqld']['version'] = '0.12.1'
default['prometheus_exporters']['mysqld']['url'] = "https://github.com/prometheus/mysqld_exporter/releases/download/v#{node['prometheus_exporters']['mysqld']['version']}/mysqld_exporter-#{node['prometheus_exporters']['mysqld']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['mysqld']['checksum'] = '133b0c281e5c6f8a34076b69ade64ab6cac7298507d35b96808234c4aa26b351'
