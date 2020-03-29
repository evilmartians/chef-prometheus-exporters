user 'postgres' do
  comment 'Mock PostgreSQL user'
  system true
end

user 'opscode-pgsql' do
  comment 'Mock Chef PostgreSQL user'
  system true
end

postgres_exporter 'main' do
  data_source_name 'postgres'
  action %i(install enable start)
end

# Second PostgreSQL exporter instance with the settings needed to
# monitor the PostgreSQL server bundled with Chef server
postgres_exporter 'chef' do
  web_listen_address '0.0.0.0:9188'
  data_source_name 'user=opscode-pgsql host=/tmp/ sslmode=disable'
  user 'opscode-pgsql'

  action %i(install enable start)
end
