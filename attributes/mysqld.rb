default['prometheus_exporters']['mysqld']['version'] = '0.10.0'
default['prometheus_exporters']['mysqld']['url'] = "https://github.com/prometheus/mysqld_exporter/releases/download/v#{node['prometheus_exporters']['mysqld']['version']}/mysqld_exporter-#{node['prometheus_exporters']['mysqld']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['mysqld']['checksum'] = '32797bc96aa00bb20e0b9165f6d3887fe9612b474061ee7de0189f5377b61859'
