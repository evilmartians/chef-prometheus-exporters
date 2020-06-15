#
# Cookbook:: prometheus_exporters
# Resource:: snmp
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :wmi_exporter
provides :wmi_exporter

property :version, String
property :enabled_collectors, String, default: 'cpu,cs,logical_disk,net,os,service,system'
property :listen_address, String, default: '0.0.0.0'
property :listen_port, String, default: '9128'
property :metrics_path, String, default: '/metrics'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['wmi']['enabled'] = true

  params = "/Enabled_Collectors:#{new_resource.enabled_collectors}"
  params += " /ListenAddress:#{new_resource.listen_address}"
  params += " /ListenPort:#{new_resource.listen_port}"
  params += " /MetricsPath:#{new_resource.metrics_path}"

  chocolatey_package 'prometheus-wmi-exporter.install' do
    action :install
    version new_resource.version
    options "--params '\"#{params}\"'"
  end
end

action :upgrade do
  params = "/Enabled_Collectors:#{new_resource.enabled_collectors}"
  params += " /ListenAddress:#{new_resource.listen_address}"
  params += " /ListenPort:#{new_resource.listen_port}"
  params += " /MetricsPath:#{new_resource.metrics_path}"

  chocolatey_package 'prometheus-wmi-exporter.install' do
    action :upgrade
    version new_resource.version
    options params
  end
end

action :uninstall do
  chocolatey_package 'prometheus-wmi-exporter.install' do
    action :remove
  end
end
