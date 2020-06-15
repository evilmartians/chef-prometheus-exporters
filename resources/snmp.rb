#
# Cookbook:: prometheus_exporters
# Resource:: snmp
#
# Copyright:: 2017, Evil Martians
#
# All rights reserved - Do Not Redistribute
#

resource_name :snmp_exporter
provides :snmp_exporter

property :config_file, String, default: '/etc/snmp_exporter/snmp.yaml'
property :custom_options, String
property :log_format, String, default: 'logfmt'
property :log_level, String, default: 'info'
property :snmp_wrap_large_counters, [true, false], default: false
property :user, String, default: 'root'
property :web_listen_address, String, default: ':9116'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['snmp']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --log.format=#{new_resource.log_format}"
  options += " --config.file=#{new_resource.config_file}"
  options += ' --snmp.wrap-large-counters' if new_resource.snmp_wrap_large_counters
  options += " #{new_resource.custom_options}" if new_resource.custom_options

  service_name = "snmp_exporter_#{new_resource.name}"

  remote_file 'snmp_exporter' do
    path "#{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['snmp']['url']
    checksum node['prometheus_exporters']['snmp']['checksum']
  end

  bash 'untar snmp_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/snmp_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[snmp_exporter]', :immediately
  end

  link '/usr/local/sbin/snmp_exporter' do
    to "/opt/snmp_exporter-#{node['prometheus_exporters']['snmp']['version']}.linux-amd64/snmp_exporter"
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
        cmd: "/usr/local/sbin/snmp_exporter #{options}",
        service_description: 'Prometheus SNMP Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus SNMP Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/snmp_exporter #{options}",
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
        cmd: "/usr/local/sbin/snmp_exporter #{options}",
        user: new_resource.user,
        service_description: 'Prometheus SNMP Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "snmp_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "snmp_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "snmp_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "snmp_exporter_#{new_resource.name}" do
    action :stop
  end
end
