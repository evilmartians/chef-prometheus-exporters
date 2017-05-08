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
property :web_listen_address, String, default: '127.0.0.1:9187'
property :web_telemetry_path, String
property :user, String, default: 'postgres'

action :install do
  run_as = user

  remote_file 'postgres_exporter' do
    path '/usr/local/sbin/postgres_exporter'
    owner 'root'
    group 'root'
    mode '0755'
    source node['prometheus_exporters']['postgres']['url']
    checksum node['prometheus_exporters']['postgres']['checksum']
  end

  options = "-web.listen-address '#{web_listen_address}'"
  options += " -web.telemetry-path '#{web_telemetry_path}'" if web_telemetry_path
  options += " -log.level #{log_level}" if log_level
  options += " -log.format '#{log_format}'"
  options += " -extend.query-path #{extend_query_path}" if extend_query_path

  environment_list = "DATA_SOURCE_NAME=#{data_source_name}"

  service "postgres_exporter_#{instance_name}" do
    action :nothing
  end

  systemd_service "postgres_exporter_#{instance_name}" do
    action [:create]
    unit do
      description 'Systemd unit for Prometheus PostgreSQL Exporter'
      after %w(network.target remote-fs.target)
      action :create
    end
    install do
      wanted_by 'multi-user.target'
    end
    service do
      type 'simple'
      user run_as
      environment environment_list
      exec_start "/usr/local/sbin/postgres_exporter #{options}"
      working_directory '/'
      restart 'on-failure'
      restart_sec '30s'
    end
    only_if { node['init_package'] == 'systemd' }
    notifies :restart, "service[postgres_exporter_#{instance_name}]"
  end

  template "/etc/init/postgres_exporter_#{instance_name}.conf" do
    cookbook 'prometheus_exporters'
    source 'upstart.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      cmd: "/usr/local/sbin/postgres_exporter #{options}",
      service_description: 'Prometheus Node Exporter',
      env: {
        'DATA_SOURCE_NAME' => data_source_name,
      },
      setuid: run_as
    )

    only_if { node['init_package'] != 'systemd' }

    notifies :restart, "service[postgres_exporter_#{instance_name}]"
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
