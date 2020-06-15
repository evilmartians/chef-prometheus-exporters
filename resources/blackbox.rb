resource_name :blackbox_exporter
provides :blackbox_exporter

property :config_file, String, default: "/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml"
property :log_level, String, default: 'info'
property :timeout_offset, String, default: '0.5'
property :user, String, default: 'root'
property :web_external_url, String, default: ''
property :web_listen_address, String, default: '0.0.0.0:9115'
property :web_route_prefix, String, default: ''

action :install do
  service_name = "blackbox_exporter_#{new_resource.name}"
  node.default['prometheus_exporters']['blackbox']['enabled'] = true

  options = "--web.listen-address=#{new_resource.web_listen_address}"
  options += " --config.file=#{new_resource.config_file}"
  options += " --timeout-offset=#{new_resource.timeout_offset}"
  options += " --log.level=#{new_resource.log_level}"
  options += " --web.external-url=#{new_resource.web_external_url}" if new_resource.web_external_url != ''
  options += " --web.route-prefix=#{new_resource.web_route_prefix}" if new_resource.web_route_prefix != ''

  prometheus_user = new_resource.respond_to?(:user) ? new_resource.user : 'root'

  # Download binary
  remote_file 'blackbox_exporter' do
    path "#{Chef::Config[:file_cache_path]}/blackbox_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['blackbox']['url']
    checksum node['prometheus_exporters']['blackbox']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar blackbox_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/blackbox_exporter.tar.gz -C /opt"
    action :nothing
    subscribes :run, 'remote_file[blackbox_exporter]', :immediately
  end

  link '/usr/local/sbin/blackbox_exporter' do
    to "/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox_exporter"
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
      owner prometheus_user
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
        user: prometheus_user,
        cmd: "/usr/local/sbin/blackbox_exporter #{options}",
        service_description: 'Prometheus Blackbox Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end
  when /systemd/
    systemd_unit "#{service_name}.service" do
      content(
        'Unit' => {
          'Description' => 'Systemd unit for Prometheus Blackbox Exporter',
          'After' => 'network.target remote-fs.target apiserver.service',
        },
        'Service' => {
          'Type' => 'simple',
          'User' => 'root',
          'ExecStart' => "/usr/local/sbin/blackbox_exporter #{options}",
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
        env: environment_list,
        user: prometheus_user,
        cmd: "/usr/local/sbin/blackbox_exporter #{options}",
        service_description: 'Prometheus Blackbox Exporter',
      )
      notifies :restart, "service[#{service_name}]"
    end

  else
    raise "Init system '#{node['init_package']}' is not supported by the 'prometheus_exporters' cookbook"
  end
end

action :enable do
  action_install
  service "blackbox_exporter_#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "blackbox_exporter_#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "blackbox_exporter_#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "blackbox_exporter_#{new_resource.name}" do
    action :stop
  end
end
