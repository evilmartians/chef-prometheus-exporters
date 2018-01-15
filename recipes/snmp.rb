#
# Cookbook Name:: prometheus_exporters
# Recipe:: snmp
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

listen_ip = node['network']['interfaces'][node['prometheus_exporters']['listen_interface']]['addresses'].find { |_address, data| data['family'] == 'inet' }.first unless node['prometheus_exporters']['disable']

snmp_exporter 'main' do
  web_listen_address "#{listen_ip}:9116"

  action %i[install enable start]

  not_if { node['prometheus_exporters']['disable'] }
end
