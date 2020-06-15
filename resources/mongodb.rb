resource_name :mongodb_exporter
provides :mongodb_exporter

property :collect_collection, [true, false], default: false
property :collect_connpoolstats, [true, false], default: false
property :collect_database, [true, false], default: false
property :collect_indexusage, [true, false], default: false
property :collect_topmetrics, [true, false], default: false
property :log_format, String, default: 'logger:stderr'
property :log_level, String, default: 'info'
property :mongodb_uri, String, default: 'mongodb://localhost:27017'
property :user, String, default: 'root'
property :web_auth_file, String
property :web_listen_address, String, default: ':9216'
property :web_ssl_cert_file, String
property :web_ssl_key_file, String
property :web_telemetry_path, String, default: '/metrics'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['mongodb']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --web.auth-file=#{new_resource.web_auth_file}" if new_resource.web_auth_file
  options += " --web.ssl-cert-file=#{new_resource.web_ssl_cert_file}" if new_resource.web_ssl_cert_file
  options += " --web.ssl-key-file=#{new_resource.web_ssl_key_file}" if new_resource.web_ssl_key_file
  options += ' --collect.database' if new_resource.collect_database
  options += ' --collect.collection' if new_resource.collect_collection
  options += ' --collect.topmetrics' if new_resource.collect_topmetrics
  options += ' --collect.indexusage' if new_resource.collect_indexusage
  options += ' --collect.connpoolstats' if new_resource.collect_connpoolstats
  options += " --mongodb.uri=#{new_resource.mongodb_uri}" if new_resource.mongodb_uri
  options += " --log.level=#{new_resource.log_level}" if new_resource.log_level
  options += " --log.format=#{new_resource.log_format}"

  service_name = "mongodb_exporter_#{new_resource.name}"
  exporter_dir = "/opt/mongodb_exporter-#{node['prometheus_exporters']['mongodb']['version']}.linux-amd64"

  directory exporter_dir do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  # Download binary
  remote_file 'mongodb_exporter' do
    path "#{Chef::Config[:file_cache_path]}/mongodb_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['mongodb']['url']
    checksum node['prometheus_exporters']['mongodb']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar mongodb_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/mongodb_exporter.tar.gz -C #{exporter_dir}"
    action :nothing
    subscribes :run, 'remote_file[mongodb_exporter]', :immediately
  end

  link '/usr/local/sbin/mongodb_exporter' do
    to "/opt/mongodb_exporter-#{node['prometheus_exporters']['mongodb']['version']}.linux-amd64/mongodb_exporter"
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
        cmd: "/usr/local/sbin/mongodb_exporter #{options}",
        service_description: 'Prometheus Mongodb Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Mongodb Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/mongodb_exporter #{options}",
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
        cmd: "/usr/local/sbin/mongodb_exporter #{options}",
        service_description: 'Prometheus Mongodb Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "mongodb_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "mongodb_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "mongodb_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "mongodb_exporter_#{new_resource.name}" do
    action :stop
  end
end
