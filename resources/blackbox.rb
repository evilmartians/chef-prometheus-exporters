resource_name :blackbox_exporter

property :web_listen_address, String, default: '0.0.0.0:9115'
property :config_file, String, default: "/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml"
property :timeout_offset, String, default: '0.5'
property :log_level, String, default: 'info'
property :user, String, default: 'root'

action :install do
  service_name = "blackbox_exporter_#{new_resource.name}"
  node.default['prometheus_exporters']['blackbox']['enabled'] = true

  options = "--web.listen-address #{new_resource.web_listen_address}"
  options += " --config.file #{new_resource.config_file}"
  options += " --timeout-offset #{new_resource.timeout_offset}"
  options += " --log.level #{new_resource.log_level}"

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

  provider = case node['init_package']
             when /init/
               :sysvinit
             when /systemd/
               :systemd
             when /upstart/
               :upstart
             end

  poise_service service_name do
    provider provider
    command "/usr/local/sbin/blackbox_exporter #{options}"
    user prometheus_user
    notifies :restart, "service[#{service_name}]"
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
