#
# Cookbook Name:: prometheus_exporters
# Resource:: postgres
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :postgres_exporter

property :instance_name, String, name_property: true
property :constant_labels, String
property :data_source_name, String, required: true
property :disable_default_metrics, [TrueClass, FalseClass], default: false
property :extend_query_path, String
property :log_format, String, default: 'logger:stdout?json=false'
property :log_level, String
property :web_listen_address, String, default: '0.0.0.0:9187'
property :web_telemetry_path, String
property :user, String, default: 'postgres'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['postgres']['enabled'] = true

  options = "--web.listen-address '#{new_resource.web_listen_address}'"
  options += " --web.telemetry-path '#{new_resource.web_telemetry_path}'" if new_resource.web_telemetry_path
  options += " --log.level #{new_resource.log_level}" if new_resource.log_level
  options += " --log.format '#{new_resource.log_format}'"
  options += " --extend.query-path #{new_resource.extend_query_path}" if new_resource.extend_query_path
  options += ' --disable-default-metrics' if new_resource.disable_default_metrics
  options += " --constantLabels='#{new_resource.constant_labels}'" if new_resource.constant_labels

  service_name = "postgres_exporter_#{new_resource.instance_name}"

  env = {
    'DATA_SOURCE_NAME' => new_resource.data_source_name,
  }

  # Download binary
  remote_file 'postgres_exporter' do
    path "#{Chef::Config[:file_cache_path]}/postgres_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['postgres']['url']
    checksum node['prometheus_exporters']['postgres']['checksum']
  end

  bash 'untar postgres_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/postgres_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[postgres_exporter]', :immediately
  end

  link '/usr/local/sbin/postgres_exporter' do
    to "/opt/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64/postgres_exporter"
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
    command "/usr/local/sbin/postgres_exporter #{options}"
    user new_resource.user
    environment env
    notifies :restart, "service[#{service_name}]"
  end
end

action :enable do
  action_install
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :enable
  end
end

action :start do
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :start
  end
end

action :disable do
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :disable
  end
end

action :stop do
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :stop
  end
end
