#
# Cookbook:: prometheus_exporters
# Recipe:: statsd
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

unless node['prometheus_exporters']['disable']
  node_port = node['prometheus_exporters']['statsd']['port']
  interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

  statsd_exporter 'main' do
    web_listen_address "#{listen_ip}:#{node_port}"

    statsd_listen_udp node['prometheus_exporters']['statsd']['listen_udp']
    statsd_listen_tcp node['prometheus_exporters']['statsd']['listen_tcp']
    statsd_listen_unixgram node['prometheus_exporters']['statsd']['listen_unixgram']
    statsd_listen_unixgram_mode node['prometheus_exporters']['statsd']['listen_unixgram_mode']
    statsd_mapping_config node['prometheus_exporters']['statsd']['mapping_config']
    statsd_read_buffer node['prometheus_exporters']['statsd']['read_buffer']
    user node['prometheus_exporters']['statsd']['user']

    action %i(install enable start)
  end
end
