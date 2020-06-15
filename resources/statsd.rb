#
# Cookbook:: prometheus_exporters
# Resource:: statsd
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :statsd_exporter
provides :statsd_exporter

property :web_listen_address, String, default: '0.0.0.0:9102'
property :web_telemetry_path, String, default: '/metrics'
property :log_level, String, default: 'info'
property :log_format, String, default: 'logfmt'
property :statsd_listen_udp, String
property :statsd_listen_tcp, String
property :statsd_listen_unixgram, String
property :statsd_listen_unixgram_mode, String
property :statsd_mapping_config, String
property :statsd_read_buffer, String
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['haproxy']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --statsd.listen-udp=#{new_resource.statsd_listen_udp}" if new_resource.statsd_listen_udp
  options += " --statsd.listen-tcp=#{new_resource.statsd_listen_tcp}" if new_resource.statsd_listen_tcp
  options += " --statsd.listen-unixgram=#{new_resource.statsd_listen_unixgram}" if new_resource.statsd_listen_unixgram
  options += " --statsd.unixsocket-mode=#{new_resource.statsd_listen_unixgram_mode}" if new_resource.statsd_listen_unixgram_mode
  options += " --statsd.mapping-config=#{new_resource.statsd_mapping_config}" if new_resource.statsd_mapping_config
  options += " --statsd.read-buffer=#{new_resource.statsd_read_buffer}" if new_resource.statsd_read_buffer

  service_name = "statsd_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'statsd_exporter' do
    path "#{Chef::Config[:file_cache_path]}/statsd_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['statsd']['url']
    checksum node['prometheus_exporters']['statsd']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar statsd_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/statsd_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[statsd_exporter]', :immediately
  end

  link '/usr/local/sbin/statsd_exporter' do
    to "/opt/statsd_exporter-#{node['prometheus_exporters']['statsd']['version']}.linux-amd64/statsd_exporter"
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
        cmd: "/usr/local/sbin/statsd_exporter #{options}",
        service_description: 'Prometheus Statsd Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Statsd Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/statsd_exporter #{options}",
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
        env: environment_list,
        user: new_resource.user,
        cmd: "/usr/local/sbin/statsd_exporter #{options}",
        service_description: 'Prometheus Statsd Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "statsd_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "statsd_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "statsd_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "statsd_exporter_#{new_resource.name}" do
    action :stop
  end
end
