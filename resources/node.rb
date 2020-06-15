#
# Cookbook:: prometheus_exporters
# Resource:: node
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

COLLECTOR_LIST = %w(
  arp
  bcache
  bonding
  buddyinfo
  conntrack
  cpu
  cpufreq
  diskstats
  drbd
  edac
  entropy
  filefd
  filesystem
  hwmon
  infiniband
  interrupts
  ipvs
  ksmd
  loadavg
  logind
  mdadm
  meminfo
  meminfo_numa
  mountstats
  netclass
  netdev
  netstat
  nfs
  nfsd
  ntp
  perf
  pressure
  processes
  qdisc
  runit
  sockstat
  stat
  supervisord
  systemd
  tcpstat
  textfile
  time
  timex
  uname
  vmstat
  wifi
  xfs
  zfs
).freeze

resource_name :node_exporter
provides :node_exporter

property :collectors_enabled, Array, callbacks: {
  'should be a collector' => lambda do |collectors|
    collectors.all? { |element| COLLECTOR_LIST.include? element }
  end,
}, default: node['prometheus_exporters']['node']['collectors_enabled'].dup
property :collectors_disabled, Array, callbacks: {
  'should be a collector' => lambda do |collectors|
    collectors.all? { |element| COLLECTOR_LIST.include? element }
  end,
}, default: []
property :collector_diskstats_ignored_devices, String
property :collector_filesystem_ignored_fs_types, String
property :collector_filesystem_ignored_mount_points, String
property :collector_netclass_ignored_devices, String
property :collector_netdev_device_blacklist, String
property :collector_netdev_device_whitelist, String
property :collector_netstat_fields, String
property :collector_ntp_ip_ttl, [String, Integer]
property :collector_ntp_local_offset_tolerance, String
property :collector_ntp_max_distance, String
property :collector_ntp_protocol_version, [String, Integer]
property :collector_ntp_server, String
property :collector_ntp_server_is_local, [true, false]
property :collector_qdisc_fixtures, String
property :collector_perf_cpus, String
property :collector_runit_servicedir, String
property :collector_supervisord_url, String
property :collector_systemd_enable_restarts_metrics, [true, false], default: false
property :collector_systemd_enable_start_time_metrics, [true, false], default: false
property :collector_systemd_enable_task_metrics, [true, false], default: false
property :collector_systemd_private, [true, false], default: false
property :collector_systemd_unit_blacklist, String
property :collector_systemd_unit_whitelist, String
property :collector_textfile_directory, String
property :collector_vmstat_fields, String
property :collector_wifi_fixtures, String
property :log_format, String, default: 'logfmt'
property :log_level, String, default: 'info'
property :path_procfs, String
property :path_rootfs, String
property :path_sysfs, String
property :user, String, default: 'root'
property :web_disable_exporter_metrics, [true, false], default: false
property :web_listen_address, String, default: ':9100'
property :web_max_requests, [String, Integer], default: 40
property :web_telemetry_path, String, default: '/metrics'

property :custom_options, String

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['node']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += ' --collector.ntp.server-is-local' if new_resource.collector_ntp_server_is_local
  options += ' --collector.systemd.enable-restarts-metrics' if new_resource.collector_systemd_enable_restarts_metrics
  options += ' --collector.systemd.enable-start-time-metrics' if new_resource.collector_systemd_enable_start_time_metrics
  options += ' --collector.systemd.enable-task-metrics' if new_resource.collector_systemd_enable_task_metrics
  options += ' --collector.systemd.private' if new_resource.collector_systemd_private
  options += ' --web.disable-exporter-metrics' if new_resource.web_disable_exporter_metrics
  options += " --collector.diskstats.ignored-devices='#{new_resource.collector_diskstats_ignored_devices}'" if new_resource.collector_diskstats_ignored_devices
  options += " --collector.filesystem.ignored-fs-types='#{new_resource.collector_filesystem_ignored_fs_types}'" if new_resource.collector_filesystem_ignored_fs_types
  options += " --collector.filesystem.ignored-mount-points='#{new_resource.collector_filesystem_ignored_mount_points}'" if new_resource.collector_filesystem_ignored_mount_points
  options += " --collector.netclass.ignored-devices='#{new_resource.collector_netclass_ignored_devices}'" if new_resource.collector_netclass_ignored_devices
  options += " --collector.netdev.device-blacklist='#{new_resource.collector_netdev_device_blacklist}'" if new_resource.collector_netdev_device_blacklist
  options += " --collector.netdev.device-whitelist='#{new_resource.collector_netdev_device_whitelist}'" if new_resource.collector_netdev_device_whitelist
  options += " --collector.netstat.fields='#{new_resource.collector_netstat_fields}'" if new_resource.collector_netstat_fields
  options += " --collector.ntp.ip-ttl=#{new_resource.collector_ntp_ip_ttl}" if new_resource.collector_ntp_ip_ttl
  options += " --collector.ntp.local-offset-tolerance=#{new_resource.collector_ntp_local_offset_tolerance}" if new_resource.collector_ntp_local_offset_tolerance
  options += " --collector.ntp.max-distance=#{new_resource.collector_ntp_max_distance}" if new_resource.collector_ntp_max_distance
  options += " --collector.ntp.protocol-version=#{new_resource.collector_ntp_protocol_version}" if new_resource.collector_ntp_protocol_version
  options += " --collector.ntp.server=#{new_resource.collector_ntp_server}" if new_resource.collector_ntp_server
  options += " --collector.qdisc.fixtures='#{new_resource.collector_qdisc_fixtures}'" if new_resource.collector_qdisc_fixtures
  options += " --collector.perf.cpus='#{new_resource.collector_perf_cpus}'" if new_resource.collector_perf_cpus
  options += " --collector.runit.servicedir='#{new_resource.collector_runit_servicedir}'" if new_resource.collector_runit_servicedir
  options += " --collector.supervisord.url='#{new_resource.collector_supervisord_url}'" if new_resource.collector_supervisord_url
  options += " --collector.systemd.unit-blacklist=#{new_resource.collector_systemd_unit_blacklist}" if new_resource.collector_systemd_unit_blacklist
  options += " --collector.systemd.unit-whitelist=#{new_resource.collector_systemd_unit_whitelist}" if new_resource.collector_systemd_unit_whitelist
  options += " --collector.textfile.directory=#{new_resource.collector_textfile_directory}" if new_resource.collector_textfile_directory
  options += " --collector.vmstat.fields='#{new_resource.collector_vmstat_fields}'" if new_resource.collector_vmstat_fields
  options += " --collector.wifi.fixtures='#{new_resource.collector_wifi_fixtures}'" if new_resource.collector_wifi_fixtures
  options += " --log.format=#{new_resource.log_format}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --path.procfs=#{new_resource.path_procfs}" if new_resource.path_procfs
  options += " --path.rootfs=#{new_resource.path_rootfs}" if new_resource.path_rootfs
  options += " --path.sysfs=#{new_resource.path_sysfs}" if new_resource.path_sysfs
  options += " --web.max-requests=#{new_resource.web_max_requests}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"

  options += " #{new_resource.custom_options}" if new_resource.custom_options

  options += new_resource.collectors_enabled.map { |c| " --collector.#{c}" }.join
  options += new_resource.collectors_disabled.map { |c| " --no-collector.#{c}" }.join unless new_resource.collectors_disabled.empty?

  service_name = "node_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'node_exporter' do
    path "#{Chef::Config[:file_cache_path]}/node_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['node']['url']
    checksum node['prometheus_exporters']['node']['checksum']
    notifies :restart, "service[#{service_name}]"
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
  service service_name do
    action :nothing
  end

  case node['init_package']
  when /init/
    %w(
      /var/run/prometheus
      /var/log/prometheus
    ).each do |dir|
      directory dir do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end
    end

    directory "/var/log/prometheus/#{service_name}" do
      owner new_resource.user
      group 'root'
      mode '0755'
      action :create
    end

    template "/etc/init.d/#{service_name}" do
      cookbook 'prometheus_exporters'
      source 'initscript.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        name: service_name,
        user: new_resource.user,
        cmd: "/usr/local/sbin/node_exporter #{options}",
        service_description: 'Prometheus Node Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Node Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/node_exporter #{options}",
          'WorkingDirectory' => '/',
          'Restart' => 'on-failure',
          'RestartSec' => '30s',
        },
        'Install' => {
          'WantedBy' => 'multi-user.target',
        },
      )
      notifies :restart, "service[#{service_name}]"
      action :create
    end

  when /upstart/
    template "/etc/init/#{service_name}.conf" do
      cookbook 'prometheus_exporters'
      source 'upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        cmd: "/usr/local/sbin/node_exporter #{options}",
        user: new_resource.user,
        service_description: 'Prometheus Node Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end

  if new_resource.collector_textfile_directory and
     new_resource.collector_textfile_directory != ''
    directory 'collector_textfile_directory' do
      path new_resource.collector_textfile_directory
      owner 'root'
      group 'root'
      mode '0755'
      action :create
      recursive true
    end
  end
end

action :enable do
  action_install
  service "node_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "node_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "node_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "node_exporter_#{new_resource.name}" do
    action :stop
  end
end
