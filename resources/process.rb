resource_name :process_exporter

property :web_listen_address, String, default: ':9256'
property :web_telemetry_path, String, default: '/metrics'
property :config_file, String
property :proc_names, String
property :name_mapping, String
property :path_procfs, String
property :children, [TrueClass, FalseClass], default: true
property :recheck, [TrueClass, FalseClass], default: false
property :debug, [TrueClass, FalseClass], default: false
property :custom_options, String

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['process']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --config.path=#{new_resource.config_file}"
  options += " --procnames=#{new_resource.proc_names}" if new_resource.proc_names
  options += " --name_mapping=#{new_resource.name_mapping}" if new_resource.name_mapping
  options += " --procfs=#{new_resource.path_procfs}" if new_resource.path_procfs
  options += ' --children=true' if new_resource.children
  options += ' --recheck=true' if new_resource.recheck
  options += ' --debug=true' if new_resource.debug
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
    %W[
      /var/run/prometheus
      /var/log/prometheus/#{service_name}
    ].each do |dir|
      directory dir do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end
    end

    template "/etc/init.d/#{service_name}" do
      cookbook 'prometheus_exporters'
      source 'initscript.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        name: service_name,
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
          'User' => 'root',
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
