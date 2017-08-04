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
property :custom_options, String

action :install do
  remote_file 'snmp_exporter' do
    path "#{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['snmp']['url']
    # checksum node['prometheus_exporters']['node']['checksum']
  end

  bash 'untar snmp_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[snmp_exporter]'
  end

  link '/usr/local/sbin/snmp_exporter' do
    to "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp_exporter"
  end

  options = "-web.listen-address #{web_listen_address}"
  options += " -log.level #{log_level}"
  options += " -log.format #{log_format}"
  options += " #{custom_options}" if custom_options

  service 'snmp_exporter' do
    action :nothing
  end

  systemd_service 'snmp_exporter' do
    unit do
      description 'Systemd unit for Prometheus SNMP Exporter'
      after %w(network.target remote-fs.target apiserver.service)
    end
    install do
      wanted_by 'multi-user.target'
    end
    service do
      type 'simple'
      user 'root'
      exec_start "/usr/local/sbin/snmp_exporter #{options}"
      working_directory '/'
      restart 'on-failure'
      restart_sec '30s'
    end

    only_if { node['platform_version'].to_i >= 16 || (node['platform_family'] == 'rhel' && node['platform_version'].to_i >= 7) }

    notifies :restart, 'service[snmp_exporter]'
  end

  template '/etc/init/snmp_exporter.conf' do
    source 'upstart.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      cmd: "/usr/local/sbin/snmp_exporter #{options}",
      service_description: 'Prometheus SNMP Exporter'
    )

    only_if { node['platform_version'].to_i < 16 && node['platform_family'] == 'debian' }

    notifies :restart, 'service[snmp_exporter]'
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
