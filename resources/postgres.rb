#
# Cookbook Name:: prometheus_exporters
# Resource:: postgres
#
# Copyright 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :postgres_exporter

property :instance_name, String, name_property: true
property :data_source_name, String, required: true
property :extend_query_path, String
property :log_format, String, default: 'logger:stdout?json=false'
property :log_level, String
property :web_listen_address, String, default: '0.0.0.0:9187'
property :web_telemetry_path, String
property :user, String, default: 'postgres'

action :install do
  service_name = "postgres_exporter_#{instance_name}"

  options = "--web.listen-address '#{web_listen_address}'"
  options += " --web.telemetry-path '#{web_telemetry_path}'" if web_telemetry_path
  options += " --log.level #{log_level}" if log_level
  options += " --log.format '#{log_format}'"
  options += " --extend.query-path #{extend_query_path}" if extend_query_path

  env = {
    'DATA_SOURCE_NAME' => data_source_name,
  }

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
    to "/opt/node_exporter-#{node['prometheus_exporters']['node']['version']}.linux-amd64/node_exporter"
    to "/opt/postgres_exporter_#{node['prometheus_exporters']['postgres']['version']}_linux-amd64/postgres_exporter"
    notifies :restart, "service[#{service_name}]"
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
  service "postgres_exporter_#{instance_name}" do
    action :enable
  end
end

action :start do
  service "postgres_exporter_#{instance_name}" do
    action :start
  end
end

action :disable do
  service "postgres_exporter_#{instance_name}" do
    action :disable
  end
end

action :stop do
  service "postgres_exporter_#{instance_name}" do
    action :stop
  end
end
