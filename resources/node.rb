#
# Cookbook Name:: prometheus_exporters
# Resource:: node
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

COLLECTOR_LIST = %w[
  arp
  bcache
  bonding
  buddyinfo
  conntrack
  cpu
  diskstats
  drbd
  edac
  entropy
  filefd
  filesystem
  gmond
  hwmon
  infiniband
  interrupts
  ipvs
  ksmd
  loadavg
  logind
  mdadm
  megacli
  meminfo
  meminfo_numa
  mountstats
  netdev
  netstat
  nfs
  ntp
  qdisc
  runit
  sockstat
  stat
  supervisord
  systemd
  tcpstat
  textfile
  time
  uname
  vmstat
  wifi
  xfs
  zfs
  timex
].freeze

resource_name :node_exporter

property :web_listen_address, String, default: ':9100'
property :web_telemetry_path, String, default: '/metrics'
property :log_level, String, default: 'info'
property :log_format, String, default: 'logger:stdout'
property :collectors_enabled, Array, callbacks: {
  'should be a collector' => lambda do |collectors|
    collectors.all? { |element| COLLECTOR_LIST.include? element }
  end,
}
property :collectors_disabled, Array, callbacks: {
  'should be a collector' => lambda do |collectors|
    collectors.all? { |element| COLLECTOR_LIST.include? element }
  end,
}
property :collector_megacli_command, String
property :collector_ntp_server, String
property :collector_ntp_protocol_version, [String, Integer]
property :collector_ntp_server_is_local, [TrueClass, FalseClass]
property :collector_ntp_ip_ttl, [String, Integer]
property :collector_ntp_max_distance, String
property :collector_ntp_local_offset_tolerance, String
property :path_procfs, String
property :path_sysfs, String
property :collector_textfile_directory, String
property :collector_netdev_ignored_devices, String
property :collector_diskstats_ignored_devices, String
property :collector_filesystem_ignored_fs_types, String
property :collector_filesystem_ignored_mount_points, String
property :custom_options, String

action :install do
  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --collector.megacli.command=#{new_resource.collector_megacli_command}" if new_resource.collector_megacli_command
  options += " --collector.ntp.server=#{new_resource.collector_ntp_server}" if new_resource.collector_ntp_server
  options += " --collector.ntp.protocol-version=#{new_resource.collector_ntp_protocol_version}" if new_resource.collector_ntp_protocol_version
  options += ' --collector.ntp.server-is-local' if new_resource.collector_ntp_server_is_local
  options += " --collector.ntp.ip-ttl=#{new_resource.collector_ntp_ip_ttl}" if new_resource.collector_ntp_ip_ttl
  options += " --collector.ntp.max-distance=#{new_resource.collector_ntp_max_distance}" if new_resource.collector_ntp_max_distance
  options += " --collector.ntp.local-offset-tolerance=#{new_resource.collector_ntp_local_offset_tolerance}" if new_resource.collector_ntp_local_offset_tolerance
  options += " --path.procfs=#{new_resource.path_procfs}" if new_resource.path_procfs
  options += " --path.sysfs=#{new_resource.path_sysfs}" if new_resource.path_sysfs
  options += " --collector.textfile.directory=#{new_resource.collector_textfile_directory}" if new_resource.collector_textfile_directory
  options += " --collector.netdev.ignored-devices='#{new_resource.collector_netdev_ignored_devices}'" if new_resource.collector_netdev_ignored_devices
  options += " --collector.diskstats.ignored-devices='#{new_resource.collector_diskstats_ignored_devices}'" if new_resource.collector_diskstats_ignored_devices
  options += " --collector.filesystem.ignored-fs-types='#{new_resource.collector_filesystem_ignored_fs_types}'" if new_resource.collector_filesystem_ignored_fs_types
  options += " --collector.filesystem.ignored-mount-points='#{new_resource.collector_filesystem_ignored_mount_points}'" if new_resource.collector_filesystem_ignored_mount_points
  options += " #{new_resource.custom_options}" if new_resource.custom_options

  options += new_resource.collectors_enabled.map { |c| " --collector.#{c}" }.join
  options += new_resource.collectors_disabled.map { |c| " --no-collector.#{c}" }.join unless new_resource.collectors_disabled.empty?

  # Download binary
  remote_file 'node_exporter' do
    path "#{Chef::Config[:file_cache_path]}/node_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['node']['url']
    checksum node['prometheus_exporters']['node']['checksum']
    notifies :restart, 'service[node_exporter]'
  end

  bash 'untar node_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/node_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[node_exporter]', :immediately
  end

  link '/usr/local/sbin/node_exporter' do
    to "/opt/node_exporter-#{node['prometheus_exporters']['node']['version']}.linux-amd64/node_exporter"
  end

  # Configure to run as a service
  service 'node_exporter' do
    action :nothing
  end

  case node['init_package']
  when /init/
    %w[
      /var/run/prometheus
      /var/log/prometheus/node_exporter
    ].each do |dir|
      directory dir do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end
    end

    template '/etc/init.d/node_exporter' do
      cookbook 'prometheus_exporters'
      source 'initscript.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        name: 'node_exporter',
        cmd: "/usr/local/sbin/node_exporter #{options}",
        service_description: 'Prometheus Node Exporter',
      )
      notifies :restart, 'service[node_exporter]'
    end

  when /systemd/
    systemd_unit 'node_exporter.service' do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Node Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => 'root',
          'ExecStart' => "/usr/local/sbin/node_exporter #{options}",
          'WorkingDirectory' => '/',
          'Restart' => 'on-failure',
          'RestartSec' => '30s',
        },
        'Install' => {
          'WantedBy' => 'multi-user.target',
        },
      )
      notifies :restart, 'service[node_exporter]'
      action :create
    end

  when /upstart/
    template '/etc/init/node_exporter.conf' do
      cookbook 'prometheus_exporters'
      source 'upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        cmd: "/usr/local/sbin/node_exporter #{options}",
        service_description: 'Prometheus Node Exporter',
      )
      notifies :restart, 'service[node_exporter]'
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end

  directory 'collector_textfile_directory' do
    path new_resource.collector_textfile_directory
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    recursive true
    only_if do
      new_resource.collector_textfile_directory and
        new_resource.collector_textfile_directory != ''
    end
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
