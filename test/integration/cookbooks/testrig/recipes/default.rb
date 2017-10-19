user 'prometheus' do
  comment 'Prometheus user'
  system true
end

node_exporter 'main' do
  collectors_enabled node['prometheus_exporters']['node']['collectors_enabled']
  collectors_disabled node['prometheus_exporters']['node']['collectors_disabled']
  collector_textfile_directory node['prometheus_exporters']['node']['textfile_directory']
  collector_netdev_ignored_devices node['prometheus_exporters']['node']['ignored_net_devs']
  collector_filesystem_ignored_mount_points node['prometheus_exporters']['node']['ignored_mount_points']

  action [:install, :enable, :start]
end

postgres_exporter 'main' do
  web_listen_address '0.0.0.0:9187'
  data_source_name 'postgres'
  action [:install, :enable, :start]
end

redis_exporter 'main' do
  action [:install, :enable, :start]
end

snmp_exporter 'main' do
  action [:install, :enable, :start]
end
