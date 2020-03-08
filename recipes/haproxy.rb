#
# Cookbook:: prometheus_exporters
# Recipe:: haproxy
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

unless node['prometheus_exporters']['disable']
  node_port = node['prometheus_exporters']['haproxy']['port']
  interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

  haproxy_exporter 'main' do
    web_listen_address "#{listen_ip}:#{node_port}"
    haproxy_scrape_uri node['prometheus_exporters']['haproxy']['scrape_uri']
    haproxy_ssl_verify node['prometheus_exporters']['haproxy']['ssl_verify']
    user node['prometheus_exporters']['haproxy']['user']

    action %i(install enable start)
  end
end
