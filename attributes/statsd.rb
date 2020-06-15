default['prometheus_exporters']['statsd']['version'] = '0.16.0'
default['prometheus_exporters']['statsd']['url'] = "https://github.com/prometheus/statsd_exporter/releases/download/v#{node['prometheus_exporters']['statsd']['version']}/statsd_exporter-#{node['prometheus_exporters']['statsd']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['statsd']['checksum'] = '02ba9020d75c56146cdd6d62fb2891e9660c4108fa827cc04314f748ab6756bc'

default['prometheus_exporters']['statsd']['port'] = 9102
default['prometheus_exporters']['statsd']['user'] = 'root'
