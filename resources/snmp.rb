#
# Cookbook Name:: prometheus_exporters
# Resource:: snmp
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :snmp_exporter

property :web_listen_address, String, default: ':9116'
property :log_level, String, default: 'info'
property :log_format, String, default: 'logger:stdout'
property :config_file, String, default: '/etc/snmp_exporter/snmp.yaml'
property :custom_options, String

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['snmp']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --config.file=#{new_resource.config_file}"
  options += " #{new_resource.custom_options}" if new_resource.custom_options

  service_name = "snmp_exporter_#{new_resource.name}"

  remote_file 'snmp_exporter' do
    path "#{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['snmp']['url']
    checksum node['prometheus_exporters']['snmp']['checksum']
  end

  bash 'untar snmp_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[snmp_exporter]', :immediately
  end

  link '/usr/local/sbin/snmp_exporter' do
    to "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp_exporter"
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
    command "/usr/local/sbin/snmp_exporter #{options}"
    notifies :restart, "service[#{service_name}]"
  end
end

action :enable do
  action_install
  service "snmp_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "snmp_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "snmp_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "snmp_exporter_#{new_resource.name}" do
    action :stop
  end
end
