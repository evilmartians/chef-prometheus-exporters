#
# Cookbook Name:: prometheus_exporters
# Resource:: redis
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :redis_exporter

property :web_listen_address, String, default: '0.0.0.0:9121'
property :web_telemetry_path, String, default: '/metrics'
property :log_format, String, default: 'txt'
property :debug, [TrueClass, FalseClass], default: false
property :check_keys, String
property :redis_addr, String, default: 'redis://localhost:6379'
property :redis_password, String
property :redis_alias, String
property :redis_file, String
property :namespace, String, default: 'redis'
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['redis']['enabled'] = true

  options = "-web.listen-address #{new_resource.web_listen_address}"
  options += " -web.telemetry-path #{new_resource.web_telemetry_path}"
  options += " -log-format #{new_resource.log_format}"
  options += ' -debug' if new_resource.debug
  options += " -check-keys #{new_resource.check_keys}" if new_resource.check_keys
  options += " -redis.addr #{new_resource.redis_addr}" if new_resource.redis_addr
  options += " -redis.password #{new_resource.redis_password}" if new_resource.redis_password
  options += " -redis.alias #{new_resource.redis_alias}" if new_resource.redis_alias
  options += " -redis.file #{new_resource.redis_file}" if new_resource.redis_file
  options += " -namespace #{new_resource.namespace}"

  service_name = "redis_exporter_#{new_resource.name}"

  remote_file 'redis_exporter' do
    path "#{Chef::Config[:file_cache_path]}/redis_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['redis']['url']
    checksum node['prometheus_exporters']['redis']['checksum']
  end

  bash 'untar redis_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/redis_exporter.tar.gz -C /usr/local/sbin/"
    action :nothing
    subscribes :run, 'remote_file[redis_exporter]', :immediately
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
    command "/usr/local/sbin/redis_exporter #{options}"
    user new_resource.user
    notifies :restart, "service[#{service_name}]"
  end
end

action :enable do
  action_install
  service "redis_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "redis_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "redis_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "redis_exporter_#{new_resource.name}" do
    action :stop
  end
end
