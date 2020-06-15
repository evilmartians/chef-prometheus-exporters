node_exporter 'first' do
  action %i(install enable start)
end

node_exporter 'second' do
  web_listen_address ':9110'
  collectors_enabled node['prometheus_exporters']['node']['collectors_enabled']
  collectors_disabled node['prometheus_exporters']['node']['collectors_disabled']
  collector_textfile_directory node['prometheus_exporters']['node']['textfile_directory']
  collector_netdev_device_blacklist node['prometheus_exporters']['node']['ignored_net_devs']
  collector_filesystem_ignored_mount_points node['prometheus_exporters']['node']['ignored_mount_points']

  action %i(install enable start)
end
