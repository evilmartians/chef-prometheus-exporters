default['prometheus_exporters']['mysqld']['version'] = '0.11.0'
default['prometheus_exporters']['mysqld']['url'] = "https://github.com/prometheus/mysqld_exporter/releases/download/v#{node['prometheus_exporters']['mysqld']['version']}/mysqld_exporter-#{node['prometheus_exporters']['mysqld']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['mysqld']['checksum'] = 'b53ad48ff14aa891eb6a959730ffc626db98160d140d9a66377394714c563acf'
