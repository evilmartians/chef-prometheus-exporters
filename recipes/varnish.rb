#
# Cookbook:: prometheus_exporters
# Recipe:: varnish
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

varnish_conf = node['prometheus_exporters']['varnish']

unless node['prometheus_exporters']['disable']
  node_port = varnish_conf['port']
  interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

  varnish_exporter 'main' do
    web_listen_address "#{listen_ip}:#{node_port}"
    web_telemetry_path varnish_conf['telemetry_path'] if varnish_conf.key? 'telemetry_path'
    varnishstat_path varnish_conf['varnishstat_path'] if varnish_conf.key? 'varnishstat_path'
    N varnish_conf['N'] if varnish_conf.key? 'N'
    docker_container_name varnish_conf['docker_container_name'] if varnish_conf.key? 'docker_container_name'
    exit_on_errors varnish_conf['exit_on_errors'] if varnish_conf.key? 'exit_on_errors'
    n varnish_conf['n'] if varnish_conf.key? 'n'
    verbose varnish_conf['verbose'] if varnish_conf.key? 'verbose'
    with_go_metrics varnish_conf['with_go_metrics'] if varnish_conf.key? 'with_go_metrics'
    user varnish_conf['user']

    action %i(install enable start)
  end
end
