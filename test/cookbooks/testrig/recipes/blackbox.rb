blackbox_exporter 'main' do
  web_listen_address '0.0.0.0:9115'
  config_file "/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml"
  timeout_offset '0.5'
  log_level 'info'

  action %i(install enable start)
end
