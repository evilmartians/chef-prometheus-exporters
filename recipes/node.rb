#
# Cookbook:: prometheus_exporters
# Recipe:: node
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

unless node['prometheus_exporters']['disable']
  node_port = node['prometheus_exporters']['node']['port']
  interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

  node_exporter 'main' do
    web_listen_address "#{listen_ip}:#{node_port}"
    collectors_enabled node['prometheus_exporters']['node']['collectors_enabled']
    collectors_disabled node['prometheus_exporters']['node']['collectors_disabled']
    collector_textfile_directory node['prometheus_exporters']['node']['textfile_directory']
    collector_netdev_device_blacklist node['prometheus_exporters']['node']['ignored_net_devs']
    collector_filesystem_ignored_mount_points node['prometheus_exporters']['node']['ignored_mount_points']
    user node['prometheus_exporters']['node']['user']

    action %i(install enable start)
  end
end
