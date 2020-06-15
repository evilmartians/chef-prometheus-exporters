#
# Cookbook:: prometheus_exporters
# Resource:: haproxy
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :haproxy_exporter
provides :haproxy_exporter

property :haproxy_pid_file, String
property :haproxy_scrape_uri, String
property :haproxy_server_metric_fields, String
property :haproxy_ssl_verify, [true, false], default: false
property :haproxy_timeout, String
property :log_format, String, default: 'logger:stdout'
property :log_level, String, default: 'info'
property :user, String, default: 'root'
property :web_listen_address, String, default: '0.0.0.0:9101'
property :web_telemetry_path, String, default: '/metrics'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['haproxy']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --haproxy.scrape-uri=#{new_resource.haproxy_scrape_uri}" if new_resource.haproxy_scrape_uri
  options += ' --haproxy.ssl-verify' if new_resource.haproxy_ssl_verify
  options += " --haproxy.server-metric-fields=#{new_resource.haproxy_server_metric_fields}" if new_resource.haproxy_server_metric_fields
  options += " --haproxy.timeout=#{new_resource.haproxy_timeout}" if new_resource.haproxy_timeout
  options += " --haproxy.pid-file=#{new_resource.haproxy_pid_file}" if new_resource.haproxy_pid_file

  service_name = "haproxy_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'haproxy_exporter' do
    path "#{Chef::Config[:file_cache_path]}/haproxy_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['haproxy']['url']
    checksum node['prometheus_exporters']['haproxy']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar haproxy_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/haproxy_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[haproxy_exporter]', :immediately
  end

  link '/usr/local/sbin/haproxy_exporter' do
    to "/opt/haproxy_exporter-#{node['prometheus_exporters']['haproxy']['version']}.linux-amd64/haproxy_exporter"
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
        cmd: "/usr/local/sbin/haproxy_exporter #{options}",
        service_description: 'Prometheus HAProxy Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus HAProxy Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/haproxy_exporter #{options}",
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
        cmd: "/usr/local/sbin/haproxy_exporter #{options}",
        service_description: 'Prometheus HAProxy Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "haproxy_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "haproxy_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "haproxy_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "haproxy_exporter_#{new_resource.name}" do
    action :stop
  end
end
