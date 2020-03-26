#
# Cookbook Name:: prometheus_exporters
# Resource:: rabbitmq
#

resource_name :rabbitmq_exporter

property :user, String, default: 'root'
property :rabbitmq_scrape_url, String, default: 'http://127.0.0.1:15672'
property :rabbitmq_user, String
property :rabbitmq_password, String
property :web_listen_port, String, default: '9419'
property :output_format, String, default: 'TTY'
property :log_level, String, default: 'info'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['rabbitmq']['enabled'] = true

  options = "RABBIT_URL=#{new_resource.rabbitmq_scrape_url}"
  options += " RABBIT_USER=#{new_resource.rabbitmq_user}" if new_resource.rabbitmq_user
  options += " RABBIT_PASSWORD=#{new_resource.rabbitmq_password}" if new_resource.rabbitmq_password
  options += " PUBLISH_PORT=#{new_resource.web_listen_port}"
  options += " OUTPUT_FORMAT=#{new_resource.output_format}"
  options += " LOG_LEVEL=#{new_resource.log_level}"

  service_name = "rabbitmq_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'rabbitmq_exporter' do
    path "#{Chef::Config[:file_cache_path]}/rabbitmq_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['rabbitmq']['url']
    checksum node['prometheus_exporters']['rabbitmq']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar rabbitmq_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/rabbitmq_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[rabbitmq_exporter]', :immediately
  end

  link '/usr/local/sbin/rabbitmq_exporter' do
    to "/opt/rabbitmq_exporter-#{node['prometheus_exporters']['rabbitmq']['version']}.linux-amd64/rabbitmq_exporter"
  end

  # Configure to run as a service
  service service_name do
    action :nothing
  end

  case node['init_package']
  when /init/
    %w[
      /var/run/prometheus
      /var/log/prometheus
    ].each do |dir|
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
        cmd: "#{options} /usr/local/sbin/rabbitmq_exporter",
        service_description: 'Prometheus RabbitMQ Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus RabbitMQ Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "#{options} /usr/local/sbin/rabbitmq_exporter",
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
        user: new_resource.user,
        cmd: "#{options} /usr/local/sbin/rabbitmq_exporter",
        service_description: 'Prometheus RabbitMQ Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "rabbitmq_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "rabbitmq_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "rabbitmq_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "rabbitmq_exporter_#{new_resource.name}" do
    action :stop
  end
end
