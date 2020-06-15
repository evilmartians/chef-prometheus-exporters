resource_name :consul_exporter
provides :consul_exporter

property :consul_allow_stale, [true, false], default: false
property :consul_ca_file, String
property :consul_cert_file, String
property :consul_health_summary, [true, false], default: false
property :consul_insecure, [true, false], default: false
property :consul_key_file, String
property :consul_require_consistent, [true, false], default: false
property :consul_server_name, String
property :consul_server, String, default: 'http://localhost:8500'
property :consul_timeout, String, default: '500ms'
property :kv_prefix, String
property :kv_filter, String, default: '.*'
property :log_format, String, default: 'logfmt'
property :log_level, String, default: 'info'
property :user, String, default: 'root'
property :web_listen_address, String, default: ':9107'
property :web_telemetry_path, String, default: '/metrics'

action :install do
  # A setting for chef discovery
  node.default['prometheus_exporters']['consul']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += ' --consul.allow_stale' if new_resource.consul_allow_stale
  options += ' --consul.health-summary' if new_resource.consul_health_summary
  options += ' --consul.insecure' if new_resource.consul_insecure
  options += ' --consul.require_consistent' if new_resource.consul_require_consistent
  options += " --consul.ca-file=#{new_resource.consul_ca_file}" if new_resource.consul_ca_file
  options += " --consul.cert-file=#{new_resource.consul_cert_file}" if new_resource.consul_cert_file
  options += " --consul.key-file=#{new_resource.consul_key_file}" if new_resource.consul_key_file
  options += " --consul.server-name=#{new_resource.consul_server_name}" if new_resource.consul_server_name
  options += " --consul.server=#{new_resource.consul_server}"
  options += " --consul.timeout=#{new_resource.consul_timeout}"
  options += " --kv.filter=#{new_resource.kv_filter}" if new_resource.kv_filter
  options += " --kv.prefix=#{new_resource.kv_prefix}" if new_resource.kv_prefix
  options += " --log.format=#{new_resource.log_format}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"

  service_name = "consul_exporter_#{new_resource.name}"

  # Download the exporter binary
  remote_file 'consul_exporter' do
    path "#{Chef::Config[:file_cache_path]}/consul_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['consul']['url']
    checksum node['prometheus_exporters']['consul']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar consul_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/consul_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[consul_exporter]', :immediately
  end

  link '/usr/local/sbin/consul_exporter' do
    to "/opt/consul_exporter-#{node['prometheus_exporters']['consul']['version']}.linux-amd64/consul_exporter"
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
        cmd: "/usr/local/sbin/consul_exporter #{options}",
        service_description: 'Prometheus Consul Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Consul Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/consul_exporter #{options}",
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
        cmd: "/usr/local/sbin/consul_exporter #{options}",
        service_description: 'Prometheus Consul Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "consul_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "consul_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "consul_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "consul_exporter_#{new_resource.name}" do
    action :stop
  end
end
