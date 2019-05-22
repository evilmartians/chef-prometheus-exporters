default['prometheus_exporters']['haproxy']['version'] = '0.10.0'
default['prometheus_exporters']['haproxy']['url'] = "https://github.com/prometheus/haproxy_exporter/releases/download/v#{node['prometheus_exporters']['haproxy']['version']}/haproxy_exporter-#{node['prometheus_exporters']['haproxy']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['haproxy']['checksum'] = '08150728e281f813a8fcfff4b336f16dbfe4268a1c7510212c8cff2579b10468'

default['prometheus_exporters']['haproxy']['port'] = 9101
default['prometheus_exporters']['haproxy']['scrape_uri'] = 'http://localhost/;csv'
default['prometheus_exporters']['haproxy']['ssl_verify'] = false
default['prometheus_exporters']['haproxy']['user'] = 'root'
