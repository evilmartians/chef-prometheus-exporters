#
# Cookbook Name:: prometheus_exporters
# Resource:: postgres
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :postgres_exporter

property :auto_discover_databases, [TrueClass, FalseClass], default: false
property :constant_labels, String
property :data_source_name, String
property :data_source_pass, String
property :data_source_pass_file, String
property :data_source_uri, String
property :data_source_user, String
property :data_source_user_file, String
property :disable_default_metrics, [TrueClass, FalseClass], default: false
property :disable_settings_metrics, [TrueClass, FalseClass], default: false
property :extend_query_path, String
property :instance_name, String, name_property: true
property :log_format, String, default: 'logger:stdout?json=false'
property :log_level, String
property :user, String, default: 'postgres'
property :web_listen_address, String, default: '0.0.0.0:9187'
property :web_telemetry_path, String

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['postgres']['enabled'] = true

  options = "--web.listen-address '#{new_resource.web_listen_address}'"
  options += " --web.telemetry-path '#{new_resource.web_telemetry_path}'" if new_resource.web_telemetry_path
  options += " --log.level #{new_resource.log_level}" if new_resource.log_level
  options += " --log.format '#{new_resource.log_format}'"
  options += " --extend.query-path #{new_resource.extend_query_path}" if new_resource.extend_query_path
  options += ' --disable-default-metrics' if new_resource.disable_default_metrics
  options += ' --disable-settings-metrics' if new_resource.disable_settings_metrics
  options += " --constantLabels='#{new_resource.constant_labels}'" if new_resource.constant_labels
  options += ' --auto-discover-databases' if new_resource.auto_discover_databases

  service_name = "postgres_exporter_#{new_resource.instance_name}"

  env = {}

  env['DATA_SOURCE_NAME'] = new_resource.data_source_name if new_resource.data_source_name
  env['DATA_SOURCE_URI'] = new_resource.data_source_uri if new_resource.data_source_uri
  env['DATA_SOURCE_USER'] = new_resource.data_source_user if new_resource.data_source_user
  env['DATA_SOURCE_USER_FILE'] = new_resource.data_source_user_file if new_resource.data_source_user_file
  env['DATA_SOURCE_PASS'] = new_resource.data_source_pass if new_resource.data_source_pass
  env['DATA_SOURCE_PASS_FILE'] = new_resource.data_source_pass_file if new_resource.data_source_pass_file

  # Download binary
  remote_file 'postgres_exporter' do
    path "#{Chef::Config[:file_cache_path]}/postgres_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['postgres']['url']
    checksum node['prometheus_exporters']['postgres']['checksum']
  end

  bash 'untar postgres_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/postgres_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[postgres_exporter]', :immediately
  end

  link '/usr/local/sbin/postgres_exporter' do
    to "/opt/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64/postgres_exporter"
  end

  service service_name do
    action :nothing
  end

  case node['init_package']
  when /init/
    %w[
      /var/run/prometheus
      /var/log/prometheus
    ].each do |dir|
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
        env: env,
        user: new_resource.user,
        name: service_name,
        cmd: "/usr/local/sbin/postgres_exporter #{options}",
        service_description: 'Prometheus PostgreSQL Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus PostgreSQL Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/postgres_exporter #{options}",
          'Environment' => env.map { |k, v| "'#{k}=#{v}'" }.join(' '),
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
        env: env,
        setuid: new_resource.user,
        cmd: "/usr/local/sbin/postgres_exporter #{options}",
        service_description: 'Prometheus PostgreSQL Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :enable
  end
end

action :start do
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :start
  end
end

action :disable do
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :disable
  end
end

action :stop do
  service "postgres_exporter_#{new_resource.instance_name}" do
    action :stop
  end
end
