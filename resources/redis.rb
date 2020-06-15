#
# Cookbook:: prometheus_exporters
# Resource:: redis
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :redis_exporter
provides :redis_exporter

property :check_keys, String
property :check_single_keys, String
property :config_command, String
property :connection_timeout, String
property :debug, [true, false], default: false
property :include_system_metrics, [true, false], default: false
property :is_tile38, [true, false], default: false
property :log_format, String, default: 'txt'
property :namespace, String, default: 'redis'
property :redis_addr, String, default: 'redis://localhost:6379'
property :redis_alias, String
property :redis_file, String
property :redis_only_metrics, [true, false], default: false
property :redis_password, String
property :redis_password_file, String
property :script, String
property :skip_tls_verification, [true, false], default: false
property :user, String, default: 'root'
property :web_listen_address, String, default: '0.0.0.0:9121'
property :web_telemetry_path, String, default: '/metrics'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['redis']['enabled'] = true

  options = "-web.listen-address '#{new_resource.web_listen_address}'"
  options += " -web.telemetry-path '#{new_resource.web_telemetry_path}'"
  options += " -log-format '#{new_resource.log_format}'"
  options += " -namespace '#{new_resource.namespace}'"
  options += " -check-keys '#{new_resource.check_keys}'" if new_resource.check_keys
  options += " -check-single-keys '#{new_resource.check_single_keys}'" if new_resource.check_single_keys
  options += " -config-command '#{new_resource.config_command}'" if new_resource.config_command
  options += " -connection-timeout '#{new_resource.connection_timeout}'" if new_resource.connection_timeout
  options += ' -debug' if new_resource.debug
  options += ' -include-system-metrics' if new_resource.include_system_metrics
  options += ' -is-tile38' if new_resource.is_tile38
  options += " -redis.addr '#{new_resource.redis_addr}'" if new_resource.redis_addr
  options += ' -redis-only-metrics' if new_resource.redis_only_metrics
  options += " -redis.password '#{new_resource.redis_password}'" if new_resource.redis_password
  options += " -script '#{new_resource.script}'" if new_resource.script
  options += ' -skip-tls-verification' if new_resource.skip_tls_verification

  service_name = "redis_exporter_#{new_resource.name}"

  remote_file 'redis_exporter' do
    path "#{Chef::Config[:file_cache_path]}/redis_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['redis']['url']
    checksum node['prometheus_exporters']['redis']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar redis_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/redis_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[redis_exporter]', :immediately
  end

  link '/usr/local/sbin/redis_exporter' do
    to "/opt/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64/redis_exporter"
  end

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
        cmd: "/usr/local/sbin/redis_exporter #{options}",
        service_description: 'Prometheus Redis Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Redis Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/redis_exporter #{options}",
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
        cmd: "/usr/local/sbin/redis_exporter #{options}",
        service_description: 'Prometheus Redis Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "redis_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "redis_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "redis_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "redis_exporter_#{new_resource.name}" do
    action :stop
  end
end
