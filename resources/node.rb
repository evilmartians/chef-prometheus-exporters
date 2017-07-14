#
# Cookbook Name:: prometheus_exporters
# Resource:: node
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :node_exporter

property :web_listen_address, String, default: ':9100'
property :web_telemetry_path, String, default: '/metrics'
property :log_level, String, default: 'info'
property :log_format, String, default: 'logger:stdout'
property :collectors_enabled, Array
property :collector_textfile_directory, String
property :collector_netdev_ignored_devices, String
property :collector_diskstats_ignored_devices, String
property :collector_filesystem_ignored_fs_types, String
property :collector_filesystem_ignored_mount_points, String
property :custom_options, String

action :install do
  remote_file 'node_exporter' do
    path "#{Chef::Config[:file_cache_path]}/node_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['node']['url']
    checksum node['prometheus_exporters']['node']['checksum']
  end

  bash 'untar node_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/node_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[node_exporter]'
  end

  link '/usr/local/sbin/node_exporter' do
    to "/opt/node_exporter-#{node['prometheus_exporters']['node']['version']}.linux-amd64/node_exporter"
  end

  options = "-web.listen-address #{web_listen_address}"
  options += " -web.telemetry-path #{web_telemetry_path}"
  options += " -log.level #{log_level}"
  options += " -log.format #{log_format}"
  options += " -collectors.enabled #{collectors_enabled.join(',')}" if collectors_enabled
  options += " -collector.textfile.directory #{collector_textfile_directory}" if collector_textfile_directory
  options += " -collector.netdev.ignored-devices '#{collector_netdev_ignored_devices}'" if collector_netdev_ignored_devices
  options += " -collector.diskstats.ignored-devices '#{collector_diskstats_ignored_devices}'" if collector_diskstats_ignored_devices
  options += " -collector.filesystem.ignored-fs-types '#{collector_filesystem_ignored_fs_types}'" if collector_filesystem_ignored_fs_types
  options += " -collector.filesystem.ignored-mount-points '#{collector_filesystem_ignored_mount_points}'" if collector_filesystem_ignored_mount_points
  options += " #{custom_options}" if custom_options

  service 'node_exporter' do
    action :nothing
  end

  case node['platform_family']
  when /rhel/
    systemd_service 'node_exporter' do
      description 'Systemd unit for Prometheus Node Exporter'
      after %w(network.target remote-fs.target apiserver.service)
      install do
        wanted_by 'multi-user.target'
      end
      service do
        type 'simple'
        user 'root'
        exec_start "/usr/local/sbin/node_exporter #{options}"
        working_directory '/'
        restart 'on-failure'
        restart_sec '30s'
      end

      only_if { node['platform_version'].to_i >= 7 }

      notifies :restart, 'service[node_exporter]'
    end

    template '/etc/init.d/node_exporter' do
      source 'node_exporter.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        cmd: "/usr/local/sbin/node_exporter #{options}",
        service_description: 'Prometheus Node Exporter'
      )

      only_if { node['platform_version'].to_i < 7 }
      notifies :restart, 'service[node_exporter]'
    end

  when /debian/
    systemd_service 'node_exporter' do
      description 'Systemd unit for Prometheus Node Exporter'
      after %w(network.target remote-fs.target apiserver.service)
      install do
        wanted_by 'multi-user.target'
      end
      service do
        type 'simple'
        user 'root'
        exec_start "/usr/local/sbin/node_exporter #{options}"
        working_directory '/'
        restart 'on-failure'
        restart_sec '30s'
      end

      only_if { node['platform_version'].to_i >= 16 }

      notifies :restart, 'service[node_exporter]'
    end

    template '/etc/init/node_exporter.conf' do
      source 'upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        cmd: "/usr/local/sbin/node_exporter #{options}",
        service_description: 'Prometheus Node Exporter'
      )

      only_if { node['platform_version'].to_i < 16 && node['platform_family'] == 'debian' }

      notifies :restart, 'service[node_exporter]'
    end
  end

  directory 'collector_textfile_directory' do
    path collector_textfile_directory
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    recursive true
    only_if { collector_textfile_directory && collector_textfile_directory != '' }
  end
end

action :enable do
  action_install
  service 'node_exporter' do
    action :enable
  end
end

action :start do
  service 'node_exporter' do
    action :start
  end
end

action :disable do
  service 'node_exporter' do
    action :disable
  end
end

action :stop do
  service 'node_exporter' do
    action :stop
  end
end
