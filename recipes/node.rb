#
# Cookbook Name:: prometheus_exporters
# Recipe:: node
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

listen_ip = node['network']['interfaces'][node['prometheus_exporters']['listen_interface']]['addresses'].find { |address, data| data['family'] == 'inet' }.first unless node['prometheus_exporters']['disable']

node_exporter 'main' do
  web_listen_address "#{listen_ip}:9100"
  collectors_enabled node['prometheus_exporters']['node']['collectors']
  collector_textfile_directory node['prometheus_exporters']['node']['textfile_directory']
  collector_netdev_ignored_devices node['prometheus_exporters']['node']['ignored_net_devs']

  action [:enable, :start]

  not_if { node['prometheus_exporters']['disable'] }
end
