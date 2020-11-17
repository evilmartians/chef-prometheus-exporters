resource_name :nginx_exporter
provides :nginx_exporter

property :nginx_retries, String, default: '5'
property :nginx_retry_interval, String, default: '5s'
property :nginx_scrape_uri, String, default: 'http://127.0.0.1:83/nginx_status'
property :nginx_ssl_ca_cert, String
property :nginx_ssl_client_cert, String
property :nginx_ssl_client_key, String
property :nginx_ssl_verify, [true, false], default: false
property :nginx_timeout, String, default: '5s'
property :prometheus_const_labels, String, default: ''
property :web_listen_address, String, default: ':9113'
property :web_telemetry_path, String, default: '/metrics'
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['nginx']['enabled'] = true

  options = "-nginx.retries=#{new_resource.nginx_retries}"
  options += " -nginx.retry-interval=#{new_resource.nginx_retry_interval}"
  options += " -nginx.scrape-uri=#{new_resource.nginx_scrape_uri}"
  options += " -nginx.ssl-ca-cert=#{new_resource.nginx_ssl_ca_cert}"
  options += " -nginx.ssl-client-cert=#{new_resource.nginx_ssl_client_cert}"
  options += " -nginx.ssl-client-key=#{new_resource.nginx_ssl_client_key}"
  options += ' -nginx.ssl-verify' if new_resource.nginx_ssl_verify
  options += " -nginx.timeout=#{new_resource.nginx_timeout}"
  options += " -prometheus.const-labels=#{new_resource.prometheus_const_labels}"
  options += " -web.listen-address=#{new_resource.web_listen_address}"
  options += " -web.telemetry-path=#{new_resource.web_telemetry_path}"

  service_name = "nginx_exporter_#{new_resource.name}"

  directory "/opt/nginx_exporter-#{node['prometheus_exporters']['nginx']['version']}.linux-amd64" do
    owner new_resource.user
    group 'root'
    mode '0755'
    action :create
  end

  # Download binary
  remote_file 'nginx_exporter' do
    path "#{Chef::Config[:file_cache_path]}/nginx_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['nginx']['url']
    checksum node['prometheus_exporters']['nginx']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar nginx_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/nginx_exporter.tar.gz -C /opt/nginx_exporter-#{node['prometheus_exporters']['nginx']['version']}.linux-amd64"
    action :nothing
    subscribes :run, 'remote_file[nginx_exporter]', :immediately
  end

  link '/usr/local/sbin/nginx_exporter' do
    to "/opt/nginx_exporter-#{node['prometheus_exporters']['nginx']['version']}.linux-amd64/nginx-prometheus-exporter"
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
        cmd: "/usr/local/sbin/nginx_exporter #{options}",
        service_description: 'Prometheus Nginx Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Nginx Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/nginx_exporter #{options}",
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
      cookbook 'nginx_exporters'
      source 'upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        cmd: "/usr/local/sbin/nginx_exporter #{options}",
        service_description: 'Prometheus Nginx Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "nginx_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "nginx_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "nginx_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "nginx_exporter_#{new_resource.name}" do
    action :stop
  end
end
