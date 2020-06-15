resource_name :process_exporter
provides :process_exporter

property :children, [true, false], default: true
property :config_path, String
property :custom_options, String
property :debug, [true, false], default: false
property :namemapping, String
property :procfs, String
property :procnames, String
property :recheck, [true, false], default: false
property :threads, [true, false], default: true
property :user, String, default: 'root'
property :web_listen_address, String, default: ':9256'
property :web_telemetry_path, String, default: '/metrics'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['process']['enabled'] = true

  options = "-web.listen-address=#{new_resource.web_listen_address}"
  options += " -web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " -config.path=#{new_resource.config_path}"
  options += " -threads=#{new_resource.threads}"
  options += " -children=#{new_resource.children}"
  options += ' -debug=true' if new_resource.debug
  options += " -namemapping='#{new_resource.namemapping}'" if new_resource.namemapping
  options += " -procfs=#{new_resource.procfs}" if new_resource.procfs
  options += " -procnames='#{new_resource.procnames}'" if new_resource.procnames
  options += ' -recheck' if new_resource.recheck
  options += " #{new_resource.custom_options}" if new_resource.custom_options

  service_name = "process_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'process_exporter' do
    path "#{Chef::Config[:file_cache_path]}/process_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['process']['url']
    checksum node['prometheus_exporters']['process']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar process_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/process_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[process_exporter]', :immediately
  end

  link '/usr/local/sbin/process_exporter' do
    to "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/process-exporter"
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
        cmd: "/usr/local/sbin/process_exporter #{options}",
        service_description: 'Prometheus Process Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Process Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/process_exporter #{options}",
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
        cmd: "/usr/local/sbin/process_exporter #{options}",
        service_description: 'Prometheus Process Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "process_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "process_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "process_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "process_exporter_#{new_resource.name}" do
    action :stop
  end
end
