default['prometheus_exporters']['nginx']['version'] = '0.8.0'
default['prometheus_exporters']['nginx']['url'] = "https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v#{node['prometheus_exporters']['nginx']['version']}/nginx-prometheus-exporter-#{node['prometheus_exporters']['nginx']['version']}-linux-amd64.tar.gz"
default['prometheus_exporters']['nginx']['checksum'] = 'fce51ce62650186f9f4cb3ff13fa4b36ffc2980058a63bccdb471c929c078e50'
default['prometheus_exporters']['nginx']['port'] = 9113