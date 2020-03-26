#
# Cookbook Name:: prometheus_exporters
# Recipe:: rabbitmq
#

unless node['prometheus_exporters']['disable']
  rabbitmq_exporter 'main' do
    rabbitmq_scrape_url node['prometheus_exporters']['rabbitmq']['scrape_url']
    rabbitmq_user 'guest'
    rabbitmq_password 'guest'
    web_listen_port node['prometheus_exporters']['rabbitmq']['port']
    output_format node['prometheus_exporters']['rabbitmq']['output_format']
    log_level node['prometheus_exporters']['rabbitmq']['log_level']
    user node['prometheus_exporters']['rabbitmq']['user']

    action %i[install enable start]
  end
end
