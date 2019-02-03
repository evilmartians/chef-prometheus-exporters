#
# Cookbook Name:: prometheus_exporters
# Resource:: haproxy
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :haproxy_exporter

property :web_listen_address, String, default: '0.0.0.0:9101'
property :web_telemetry_path, String, default: '/metrics'
property :log_level, String, default: 'info'
property :log_format, String, default: 'logger:stdout'
property :haproxy_scrape_uri, String
property :haproxy_ssl_verify, String
property :haproxy_server_metric_fields, String
property :haproxy_timeout, String
property :haproxy_pid_file, String
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['haproxy']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --haproxy.scrape-uri=#{new_resource.haproxy_scrape_uri}" if new_resource.haproxy_scrape_uri
  options += ' --haproxy.ssl-verify' if new_resource.haproxy_ssl_verify
  options += " --haproxy.server-metric-fields=#{new_resource.haproxy_server_metric_fields}" if new_resource.haproxy_server_metric_fields
  options += " --haproxy.timeout=#{new_resource.haproxy_timeout}" if new_resource.haproxy_timeout
  options += " --haproxy.pid-file=#{new_resource.haproxy_pid_file}" if new_resource.haproxy_pid_file

  service_name = "haproxy_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'haproxy_exporter' do
    path "#{Chef::Config[:file_cache_path]}/haproxy_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['haproxy']['url']
    checksum node['prometheus_exporters']['haproxy']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar haproxy_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/haproxy_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[haproxy_exporter]', :immediately
  end

  link '/usr/local/sbin/haproxy_exporter' do
    to "/opt/haproxy_exporter-#{node['prometheus_exporters']['haproxy']['version']}.linux-amd64/haproxy_exporter"
  end

  # Configure to run as a service
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
    command "/usr/local/sbin/haproxy_exporter #{options}"
    user new_resource.user
    notifies :restart, "service[#{service_name}]"
  end
end

action :enable do
  action_install
  service "haproxy_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "haproxy_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "haproxy_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "haproxy_exporter_#{new_resource.name}" do
    action :stop
  end
end
