#
# Cookbook Name:: prometheus_exporters
# Resource:: mysqld
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :mysqld_exporter

property :instance_name, String, name_property: true
property :data_source_name, String, required: true
property :log_format, String, default: 'logger:stdout?json=false'
property :log_level, String
property :web_listen_address, String, default: '0.0.0.0:9104'
property :web_telemetry_path, String
property :config_my_cnf, String, default: '~/.my.cnf'
property :user, String, default: 'mysql'
property :collector_flags, String, default: "\
--collect.global_status \
--collect.engine_innodb_status \
--collect.global_variables \
--collect.info_schema.clientstats \
--collect.info_schema.innodb_metrics \
--collect.info_schema.processlist \
--collect.info_schema.tables.databases '*' \
--collect.info_schema.tablestats \
--collect.slave_status \
--collect.binlog_size \
--collect.perf_schema.tableiowaits \
--collect.perf_schema.indexiowaits \
--collect.perf_schema.tablelocks"

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['mysqld']['enabled'] = true

  service_name = "mysqld_exporter_#{new_resource.instance_name}"

  options = "--web.listen-address '#{new_resource.web_listen_address}'"
  options += " --web.telemetry-path '#{new_resource.web_telemetry_path}'" if new_resource.web_telemetry_path
  options += " --config.my-cnf '#{new_resource.config_my_cnf}'" if new_resource.config_my_cnf
  options += " --log.level #{new_resource.log_level}" if new_resource.log_level
  options += " --log.format '#{new_resource.log_format}'"
  options += " #{new_resource.collector_flags}" if new_resource.collector_flags

  env = {
    'DATA_SOURCE_NAME' => new_resource.data_source_name,
  }

  remote_file 'mysqld_exporter' do
    path "#{Chef::Config[:file_cache_path]}/mysqld_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['mysqld']['url']
    checksum node['prometheus_exporters']['mysqld']['checksum']
  end

  bash 'untar mysqld_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/mysqld_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[mysqld_exporter]', :immediately
  end

  link '/usr/local/sbin/mysqld_exporter' do
    to "/opt/mysqld_exporter-#{node['prometheus_exporters']['mysqld']['version']}.linux-amd64/mysqld_exporter"
  end

  service service_name do
    action :nothing
  end

  provider = case node['init_package']
             when /init/
               :sysvinit
             when /systemd/
               :systemd
             when /upstart/
               :upstart
             end

  poise_service service_name do
    provider provider
    command "/usr/local/sbin/mysqld_exporter #{options}"
    user new_resource.user
    environment env
    notifies :restart, "service[#{service_name}]"
  end
end

action :enable do
  action_install
  service "mysqld_exporter_#{new_resource.instance_name}" do
    action :enable
  end
end

action :start do
  service "mysqld_exporter_#{new_resource.instance_name}" do
    action :start
  end
end

action :disable do
  service "mysqld_exporter_#{new_resource.instance_name}" do
    action :disable
  end
end

action :stop do
  service "mysqld_exporter_#{new_resource.instance_name}" do
    action :stop
  end
end
