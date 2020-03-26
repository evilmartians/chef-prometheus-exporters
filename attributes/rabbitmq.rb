default['prometheus_exporters']['rabbitmq']['version'] = '1.0.0-RC6.1'
default['prometheus_exporters']['rabbitmq']['url'] = "https://github.com/kbudde/rabbitmq_exporter/releases/download/v#{node['prometheus_exporters']['rabbitmq']['version']}/rabbitmq_exporter-#{node['prometheus_exporters']['rabbitmq']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['rabbitmq']['checksum'] = 'd4a60a924bda5235159cad61cf60ec2da209e2ff07f6ddf31745b38b2d4246b2'

default['prometheus_exporters']['rabbitmq']['user'] = 'root'
default['prometheus_exporters']['rabbitmq']['port'] = 9419
default['prometheus_exporters']['rabbitmq']['scrape_url'] = 'http://127.0.0.1:15672'
default['prometheus_exporters']['rabbitmq']['output_format'] = 'TTY'
default['prometheus_exporters']['rabbitmq']['log_level'] = 'info'


