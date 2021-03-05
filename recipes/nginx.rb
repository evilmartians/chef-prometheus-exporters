#
# Cookbook:: prometheus_exporters
# Recipe:: nginx
#
# Copyright:: 2020, Dor Mull-or
#
# All rights reserved - Do Not Redistribute
#

unless node['prometheus_exporters']['disable']
  node_port = node['prometheus_exporters']['nginx']['port']
  interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

  nginx_exporter 'main' do
    web_listen_address "#{listen_ip}:#{node_port}"
    action %i(install enable start)
  end
end
