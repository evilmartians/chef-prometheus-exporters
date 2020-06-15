default['prometheus_exporters']['wmi']['version'] = '0.13.0'

default['prometheus_exporters']['wmi']['enabled_collectors'] = %w(
  cpu
  cs
  logical_disk
  net
  os
  service
  system
)

default['prometheus_exporters']['wmi']['listen_address'] = '0.0.0.0'
default['prometheus_exporters']['wmi']['listen_port'] = '9182'
default['prometheus_exporters']['wmi']['metrics_path'] = '/metrics'
