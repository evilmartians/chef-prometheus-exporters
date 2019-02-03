#
# Cookbook Name:: prometheus_exporters
# Resource:: apache
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :apache_exporter

property :telemetry_address, String, default: ':9117'
property :telemetry_endpoint, String, default: '/metrics'
property :scrape_uri, String, default: 'http://localhost/server-status/?auto'
property :insecure, [TrueClass, FalseClass], default: false
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['apache']['enabled'] = true

  options = "-telemetry.address #{new_resource.telemetry_address}"
  options += " -telemetry.endpoint #{new_resource.telemetry_endpoint}"
  options += " -scrape_uri #{new_resource.scrape_uri}"
  options += " -insecure #{new_resource.insecure}"

  service_name = "apache_exporter_#{new_resource.name}"

  remote_file 'apache_exporter' do
    path "#{Chef::Config[:file_cache_path]}/apache_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['apache']['url']
    checksum node['prometheus_exporters']['apache']['checksum']
  end

  bash 'untar apache_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/apache_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[apache_exporter]', :immediately
  end

  link '/usr/local/sbin/apache_exporter' do
    to "/opt/apache_exporter-#{node['prometheus_exporters']['apache']['version']}.linux-amd64/apache_exporter"
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
    command "/usr/local/sbin/apache_exporter #{options}"
    user new_resource.user
    notifies :restart, "service[#{service_name}]"
  end
end

action :enable do
  action_install
  service "apache_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "apache_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "apache_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "apache_exporter_#{new_resource.name}" do
    action :stop
  end
end
