default['prometheus_exporters']['apache']['version'] = '0.8.0'
default['prometheus_exporters']['apache']['url'] = "https://github.com/Lusitaniae/apache_exporter/releases/download/v#{node['prometheus_exporters']['apache']['version']}/apache_exporter-#{node['prometheus_exporters']['apache']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['apache']['checksum'] = '8f952aa99b338a14a3c71591123c14c742cf238da83f3591879ad69f9d6b9080'
