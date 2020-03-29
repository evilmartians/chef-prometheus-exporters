#
# Cookbook:: prometheus_exporters
# Recipe:: rabbitmq
#

unless node['prometheus_exporters']['disable']
  rabbitmq_exporter 'main' do
    exclude_metrics node['prometheus_exporters']['rabbitmq']['exclude_metrics']
    include_queues node['prometheus_exporters']['rabbitmq']['include_queues']
    include_queues node['prometheus_exporters']['rabbitmq']['include_vhost']
    log_level node['prometheus_exporters']['rabbitmq']['log_level']
    max_queues node['prometheus_exporters']['rabbitmq']['max_queues']
    output_format node['prometheus_exporters']['rabbitmq']['output_format']
    publish_addr node['prometheus_exporters']['rabbitmq']['publish_addr']
    publish_port node['prometheus_exporters']['rabbitmq']['publish_port']
    rabbit_capabilities node['prometheus_exporters']['rabbitmq']['rabbit_capabilities']
    rabbit_exporters node['prometheus_exporters']['rabbitmq']['rabbit_exporters']
    rabbit_password node['prometheus_exporters']['rabbitmq']['rabbit_password']
    rabbit_url node['prometheus_exporters']['rabbitmq']['rabbit_url']
    rabbit_user node['prometheus_exporters']['rabbitmq']['rabbit_user']
    skip_queues node['prometheus_exporters']['rabbitmq']['skip_queues']
    skip_vhost node['prometheus_exporters']['rabbitmq']['skip_vhost']
    skipverify node['prometheus_exporters']['rabbitmq']['skipverify']
    user node['prometheus_exporters']['rabbitmq']['user']

    action %i(install enable start)
  end
end
