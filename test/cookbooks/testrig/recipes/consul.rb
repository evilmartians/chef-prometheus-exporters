consul_exporter 'main' do
  action %i(install enable start)
  consul_allow_stale true
  consul_health_summary true
  consul_insecure true
end
