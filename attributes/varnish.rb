default['prometheus_exporters']['varnish']['version'] = '1.5.1'
default['prometheus_exporters']['varnish']['url'] = "https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/#{node['prometheus_exporters']['varnish']['version']}/prometheus_varnish_exporter-1.5.1.linux-386.tar.gz"
default['prometheus_exporters']['varnish']['checksum'] = '9e5fb68cd172d42f4eae1eeef05507111c127e5aa867c23ff715ebf7dc42fb42'
default['prometheus_exporters']['varnish']['user'] = 'root'
