unless node['prometheus_exporters']['disable']
  node_port = node['prometheus_exporters']['process']['port']
  interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

  process_exporter 'main' do
    web_listen_address "#{listen_ip}:#{node_port}"
    config_path "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/all.yml"
    user node['prometheus_exporters']['process']['user']

    action %i(install enable)
  end

  file "/opt/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64/all.yml" do
    content <<HERE
      process_names:
      - name: "{{.Comm}}"
        cmdline:
        - '.+'
HERE
    notifies :start, 'process_exporter[main]'
  end

end
