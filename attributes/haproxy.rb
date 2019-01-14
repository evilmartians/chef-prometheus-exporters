default['prometheus_exporters']['haproxy']['version'] = '0.9.0'
default['prometheus_exporters']['haproxy']['url'] = "https://github.com/prometheus/haproxy_exporter/releases/download/v#{node['prometheus_exporters']['haproxy']['version']}/haproxy_exporter-#{node['prometheus_exporters']['haproxy']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['haproxy']['checksum'] = 'b0d1caaaf245d3d16432de9504575b3af1fec14b2206a468372a80843be001a0'

default['prometheus_exporters']['haproxy']['port'] = 9101
default['prometheus_exporters']['haproxy']['scrape_uri'] = 'http://localhost/;csv'
default['prometheus_exporters']['haproxy']['ssl_verify'] = false
default['prometheus_exporters']['haproxy']['user'] = 'root'
