#
# Cookbook:: prometheus_exporters
# Resource:: varnish
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :varnish_exporter
provides :varnish_exporter

property :varnishstat_path, String, default: 'varnishstat'
property :web_listen_address, String, default: ':9131'
property :web_telemetry_path, String, default: '/metrics'
property :N, String
property :docker_container_name, String
property :exit_on_errors, [true, false], default: false
property :n, String
property :verbose, [true, false], default: false
property :with_go_metrics, [true, false], default: false
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['varnish']['enabled'] = true

  options = "-web.listen-address #{new_resource.web_listen_address}"
  options += " -web.telemetry-path #{new_resource.web_telemetry_path}"
  options += " -varnishstat-path #{new_resource.varnishstat_path}"
  options += " -N #{new_resource.N}" if new_resource.N
  options += " -docker-container-name #{new_resource.docker_container_name}" if new_resource.docker_container_name
  options += ' -exit-on-errors' if new_resource.exit_on_errors
  options += " -n #{new_resource.n}" if new_resource.n
  options += ' -verbose' if new_resource.verbose
  options += ' -with-go-metrics' if new_resource.with_go_metrics

  service_name = "varnish_exporter_#{new_resource.name}"

  remote_file 'varnish_exporter' do
    path "#{Chef::Config[:file_cache_path]}/varnish_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['varnish']['url']
    checksum node['prometheus_exporters']['varnish']['checksum']
  end

  bash 'untar varnish_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/varnish_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[varnish_exporter]', :immediately
  end

  link '/usr/local/sbin/varnish_exporter' do
    to "/opt/prometheus_varnish_exporter-#{node['prometheus_exporters']['varnish']['version']}.linux-amd64/prometheus_varnish_exporter"
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
        cmd: "/usr/local/sbin/varnish_exporter #{options}",
        service_description: 'Prometheus varnish Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus varnish Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/varnish_exporter #{options}",
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
        cmd: "/usr/local/sbin/varnish_exporter #{options}",
        service_description: 'Prometheus varnish Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "varnish_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "varnish_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "varnish_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "varnish_exporter_#{new_resource.name}" do
    action :stop
  end
end
