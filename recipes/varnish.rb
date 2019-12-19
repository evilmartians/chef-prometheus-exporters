#
# Cookbook Name:: prometheus_exporters
# Recipe:: varnish
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

unless node['prometheus_exporters']['disable']
  varnish_exporter 'main' do
    varnishstat node['prometheus_exporters']['varnish']['varnishstat']
    user node['prometheus_exporters']['varnish']['user']
    telemetry_address node['prometheus_exporters']['varnish']['telemetry_address']
    telemetry_endpoint node['prometheus_exporters']['varnish']['telemetry_endpoint']

    action %i[install enable start]
  end
end
