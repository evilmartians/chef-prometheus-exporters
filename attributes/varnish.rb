default['prometheus_exporters']['varnish']['version'] = '1.5.2'
default['prometheus_exporters']['varnish']['url'] = "https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/#{node['prometheus_exporters']['varnish']['version']}/prometheus_varnish_exporter-#{node['prometheus_exporters']['varnish']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['varnish']['checksum'] = '3ee8c4c59aea1c341b9f4750950f24c8e6d9670ae39ed44af273f08ea318ede8'
default['prometheus_exporters']['varnish']['port'] = 9131
default['prometheus_exporters']['varnish']['user'] = 'root'
