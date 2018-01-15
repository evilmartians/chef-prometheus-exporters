#
# Cookbook Name:: prometheus_exporters
# Resource:: snmp
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :snmp_exporter

property :web_listen_address, String, default: ':9116'
property :log_level, String, default: 'info'
property :log_format, String, default: 'logger:stdout'
property :config_file, String, default: '/etc/snmp_exporter/snmp.yaml'
property :custom_options, String

action :install do
  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --config.file=#{new_resource.config_file}"
  options += " #{new_resource.custom_options}" if new_resource.custom_options

  remote_file 'snmp_exporter' do
    path "#{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['snmp']['url']
    checksum node['prometheus_exporters']['snmp']['checksum']
  end

  bash 'untar snmp_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[snmp_exporter]', :immediately
  end

  link '/usr/local/sbin/snmp_exporter' do
    to "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp_exporter"
  end

  service 'snmp_exporter' do
    action :nothing
  end

  case node['init_package']
  when /init/
    %w[
      /var/run/prometheus
      /var/log/prometheus/snmp_exporter
    ].each do |dir|
      directory dir do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end
    end

    template '/etc/init.d/snmp_exporter' do
      cookbook 'prometheus_exporters'
      source 'initscript.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        name: 'snmp_exporter',
        cmd: "/usr/local/sbin/snmp_exporter #{options}",
        service_description: 'Prometheus SNMP Exporter',
      )
      notifies :restart, 'service[snmp_exporter]'
    end

  when /systemd/
    systemd_unit 'snmp_exporter.service' do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus SNMP Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => 'root',
          'ExecStart' => "/usr/local/sbin/snmp_exporter #{options}",
          'WorkingDirectory' => '/',
          'Restart' => 'on-failure',
          'RestartSec' => '30s',
        },
        'Install' => {
          'WantedBy' => 'multi-user.target',
        },
      )
      notifies :restart, 'service[snmp_exporter]'
      action :create
    end

  when /upstart/
    template '/etc/init/snmp_exporter.conf' do
      cookbook 'prometheus_exporters'
      source 'upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        cmd: "/usr/local/sbin/snmp_exporter #{options}",
        service_description: 'Prometheus SNMP Exporter',
      )
      notifies :restart, 'service[snmp_exporter]'
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service 'snmp_exporter' do
    action :enable
  end
end

action :start do
  service 'snmp_exporter' do
    action :start
  end
end

action :disable do
  service 'snmp_exporter' do
    action :disable
  end
end

action :stop do
  service 'snmp_exporter' do
    action :stop
  end
end
