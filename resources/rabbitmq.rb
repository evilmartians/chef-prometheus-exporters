#
# Cookbook Name:: prometheus_exporters
# Resource:: rabbitmq
#

resource_name :rabbitmq_exporter

property :cafile, String
property :certfile, String
property :exclude_metrics, [String, Array]
property :include_queues, String
property :include_vhost, String
property :keyfile, String
property :log_level, String, default: 'info', equal_to: %w[debug info warning error fatal panic]
property :max_queues, Integer, default: 0
property :output_format, String, default: 'TTY', equal_to: %w[TTY JSON]
property :publish_addr, String
property :publish_port, Integer, default: 9419
property :rabbit_capabilities, String, default: 'bert,no_sort'
property :rabbit_exporters, [String, Array], default: %w[exchange node overview queue]
property :rabbit_password, String, sensitive: true
property :rabbit_timeout, Integer, default: 30
property :rabbit_url, String, default: 'http://127.0.0.1:15672'
property :rabbit_user, String
property :skip_queues, String
property :skip_vhost, String
property :skipverify, [true, false], default: false
property :user, String, default: 'root'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['rabbitmq']['enabled'] = true

  options = {}
  options['ca_file'] = new_resource.cafile if new_resource.cafile
  options['cert_file'] = new_resource.certfile if new_resource.certfile
  if new_resource.exclude_metrics
    options['exclude_metrics'] = if new_resource.exclude_metrics.kind_of?(String)
                                   new_resource.exclude_metrics.split(/\s*,\s*/) - ['']
                                 else
                                   new_resource.exclude_metrics
                                 end
  end
  options['include_queues'] = new_resource.include_queues if new_resource.include_queues
  options['include_vhost'] = new_resource.include_vhost if new_resource.include_vhost
  options['key_file'] = new_resource.keyfile if new_resource.keyfile
  options['max_queues'] = new_resource.max_queues
  options['output_format'] = new_resource.output_format
  options['publish_addr'] = new_resource.publish_addr if new_resource.publish_addr
  options['publish_port'] = new_resource.publish_port
  options['rabbit_capabilities'] = new_resource.rabbit_capabilities
  if new_resource.rabbit_exporters
    options['enabled_exporters'] = if new_resource.rabbit_exporters.kind_of?(String)
                                     new_resource.rabbit_exporters.split(/\s*,\s*/) - ['']
                                   else
                                     new_resource.rabbit_exporters
                                   end
  end
  options['rabbit_pass'] = new_resource.rabbit_password if new_resource.rabbit_password
  options['timeout'] = new_resource.rabbit_timeout
  options['rabbit_url'] = new_resource.rabbit_url
  options['rabbit_user'] = new_resource.rabbit_user if new_resource.rabbit_user
  options['skip_queues'] = new_resource.skip_queues if new_resource.skip_queues
  options['skip_vhost'] = new_resource.skip_vhost if new_resource.skip_vhost
  options['insecure_skip_verify'] = new_resource.skipverify

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

  file "/etc/#{service_name}.json" do
    owner 'root'
    group 'root'
    mode '0644'
    content options.to_json
    notifies :restart, "service[#{service_name}]", :delayed
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
        cmd: "/usr/local/sbin/rabbitmq_exporter -config-file /etc/#{service_name}.json",
        service_description: 'Prometheus RabbitMQ Exporter',
        env: {'LOG_LEVEL' => new_resource.log_level},
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
          'Environment' => {'LOG_LEVEL' => new_resource.log_level},
          'ExecStart' => "/usr/local/sbin/rabbitmq_exporter -config-file /etc/#{service_name}.json",
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
        cmd: "/usr/local/sbin/rabbitmq_exporter -config-file /etc/#{service_name}.json",
        service_description: 'Prometheus RabbitMQ Exporter',
        env: {'LOG_LEVEL' => new_resource.log_level},
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
