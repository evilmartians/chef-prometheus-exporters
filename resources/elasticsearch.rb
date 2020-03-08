resource_name :elasticsearch_exporter

property :uri, String, default: 'http://localhost:9200'
property :all, [TrueClass, FalseClass], default: false
property :cluster_settings, [TrueClass, FalseClass], default: false
property :indices, [TrueClass, FalseClass], default: false
property :indices_settings, [TrueClass, FalseClass], default: false
property :shards, [TrueClass, FalseClass], default: false
property :snapshots, [TrueClass, FalseClass], default: false
property :timeout, String, default: '5s'
property :ca, String
property :client_private_key, String
property :client_cert, String
property :clusterinfo_interval, String, default: '5m'
property :ssl_skip_verify, [TrueClass, FalseClass], default: false
property :user, String, default: 'root'
property :web_listen_address, String, default: ':9114'
property :web_telemetry_path, String, default: '/metrics'

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['elasticsearch']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --web.telemetry-path=#{new_resource.web_telemetry_path}"
  options += " --es.uri=#{new_resource.uri}"
  options += ' --es.all' if new_resource.all
  options += ' --es.indices' if new_resource.indices
  options += ' --es.indices_settings' if new_resource.indices_settings
  options += ' --es.shards' if new_resource.shards
  options += ' --es.snapshots' if new_resource.snapshots
  options += " --es.timeout=#{new_resource.timeout}"
  options += " --es.ca=#{new_resource.ca}" if new_resource.ca
  options += " --es.client-private-key=#{new_resource.client_private_key}" if new_resource.client_private_key
  options += " --es.client-cert=#{new_resource.client_cert}" if new_resource.client_cert
  options += " --es.clusterinfo.interval=#{new_resource.clusterinfo_interval}"
  options += ' --es.ssl-skip-verify' if new_resource.ssl_skip_verify

  service_name = "elasticsearch_exporter_#{new_resource.name}"

  # Download binary
  remote_file 'elasticsearch_exporter' do
    path "#{Chef::Config[:file_cache_path]}/elasticsearch_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['elasticsearch']['url']
    checksum node['prometheus_exporters']['elasticsearch']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar elasticsearch_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/elasticsearch_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[elasticsearch_exporter]', :immediately
  end

  link '/usr/local/sbin/elasticsearch_exporter' do
    to "/opt/elasticsearch_exporter-#{node['prometheus_exporters']['elasticsearch']['version']}.linux-amd64/elasticsearch_exporter"
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
        cmd: "/usr/local/sbin/elasticsearch_exporter #{options}",
        service_description: 'Prometheus Elasticsearch Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Elasticsearch Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => new_resource.user,
          'ExecStart' => "/usr/local/sbin/elasticsearch_exporter #{options}",
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
        cmd: "/usr/local/sbin/elasticsearch_exporter #{options}",
        service_description: 'Prometheus Elasticsearch Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "elasticsearch_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "elasticsearch_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "elasticsearch_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "elasticsearch_exporter_#{new_resource.name}" do
    action :stop
  end
end
