#
# Cookbook:: prometheus_exporters
# Resource:: apache
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :apache_exporter
provides :apache_exporter

property :host_override, String, default: ''
property :insecure, [true, false], default: false
property :log_format, String, default: 'logger:stdout'
property :log_level, String, default: 'info'
property :scrape_uri, String, default: 'http://localhost/server-status/?auto'
property :telemetry_address, String, default: ':9117'
property :telemetry_endpoint, String, default: '/metrics'
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['apache']['enabled'] = true

  options = "--telemetry.address #{new_resource.telemetry_address}"
  options += " --host_override #{new_resource.host_override}" if new_resource.host_override != ''
  options += ' --insecure' if new_resource.insecure
  options += " --log.format=#{new_resource.log_format}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --scrape_uri #{new_resource.scrape_uri}"
  options += " --telemetry.endpoint #{new_resource.telemetry_endpoint}"

  service_name = "apache_exporter_#{new_resource.name}"

  remote_file 'apache_exporter' do
    path "#{Chef::Config[:file_cache_path]}/apache_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['apache']['url']
    checksum node['prometheus_exporters']['apache']['checksum']
  end

  bash 'untar apache_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/apache_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[apache_exporter]', :immediately
  end

  link '/usr/local/sbin/apache_exporter' do
    to "/opt/apache_exporter-#{node['prometheus_exporters']['apache']['version']}.linux-amd64/apache_exporter"
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
        cmd: "/usr/local/sbin/apache_exporter #{options}",
        service_description: 'Prometheus Apache Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Apache Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/apache_exporter #{options}",
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
    p environment_list

    template "/etc/init/#{service_name}.conf" do
      cookbook 'prometheus_exporters'
      source 'upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        env: environment_list,
        user: new_resource.user,
        cmd: "/usr/local/sbin/apache_exporter #{options}",
        service_description: 'Prometheus Apache Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "apache_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "apache_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "apache_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "apache_exporter_#{new_resource.name}" do
    action :stop
  end
end
