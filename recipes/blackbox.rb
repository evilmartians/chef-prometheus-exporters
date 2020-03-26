unless node['prometheus_exporters']['disable']

  blackbox_exporter 'main' do
    web_listen_address '0.0.0.0:9115'
    config_file "/opt/blackbox_exporter-#{node['prometheus_exporters']['blackbox']['version']}.linux-amd64/blackbox.yml"
    timeout_offset node['prometheus_exporters']['blackbox']['timeout_offset']
    log_level node['prometheus_exporters']['blackbox']['log_level']

    action %i(install enable start)
  end
end
