rabbitmq_exporter 'main' do
  action %i(install enable start)
  include_queues 'nya.*'
end
