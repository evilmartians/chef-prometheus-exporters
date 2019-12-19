directory '/etc/mysqld' do
  action :create
end

file '/etc/mysqld/my.cnf' do
  content 'user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
'
  action :create
end
user 'mysql' do
  comment 'Mock Mysql user'
  system true
end
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

mysqld_exporter 'main' do
  data_source_name '/'
  config_my_cnf '/etc/mysqld/my.cnf'
  user 'mysql'

  action %i[install enable start]
end

node_exporter 'first' do
  action %i[install enable start]
end

node_exporter 'second' do
  web_listen_address ':9110'
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

blackbox_exporter 'main' do
  web_listen_address '0.0.0.0:9115'
  config_file "/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml"
  timeout_offset '0.5'
  log_level 'info'

  action %i[install enable start]
end

file '/etc/process_exporter_test.yml' do
  content <<HERE
    process_names:
    - name: "{{.Comm}}"
      cmdline:
      - '.+'
HERE
end

process_exporter 'main' do
  config_path '/etc/process_exporter_test.yml'

  action %i[install enable start]
end

haproxy_exporter 'main' do
  action %i[install enable start]
end

# Apache Exporter Stuff
apache_exporter 'main' do
  action %i[install enable start]
end

statsd_exporter 'main' do
  action %i[install enable start]
end

varnish_exporter 'main' do
  action %i[install enable start]
end
