user 'prometheus' do
  comment 'Prometheus user'
  system true
end

user 'postgres' do
  comment 'Mock PostgreSQL user'
  system true
end

user 'opscode-pgsql' do
  comment 'Mock Chef PostgreSQL user'
  system true
end

node_exporter 'main' do
  collectors_enabled node['prometheus_exporters']['node']['collectors_enabled']
  collectors_disabled node['prometheus_exporters']['node']['collectors_disabled']
  collector_textfile_directory node['prometheus_exporters']['node']['textfile_directory']
  collector_netdev_ignored_devices node['prometheus_exporters']['node']['ignored_net_devs']
  collector_filesystem_ignored_mount_points node['prometheus_exporters']['node']['ignored_mount_points']

  action %i[install enable start]
end

redis_exporter 'main' do
  action %i[install enable start]
end

snmp_exporter 'main' do
  config_file "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp.yml"
  action %i[install enable start]
end

postgres_exporter 'main' do
  data_source_name 'postgres'
  action %i[install enable start]
end

# Second PostgreSQL exporter instance with the settings needed to
# monitor the PostgreSQL server bundled with Chef server
postgres_exporter 'chef' do
  web_listen_address '0.0.0.0:9188'
  data_source_name 'user=opscode-pgsql host=/tmp/ sslmode=disable'
  user 'opscode-pgsql'

  action %i[install enable start]
end
