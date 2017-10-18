describe port(9100) do
  it { should be_listening }
  its('processes') { should include 'node_exporter' }
end

describe port(9121) do
  it { should be_listening }
  its('processes') { should include 'redis_exporte' }
end

describe port(9187) do
  it { should be_listening }
  its('processes') { should include 'postgres_expo' }
end

describe service('node_exporter') do
  it { should be_enabled }
  it { should be_running }
end

describe service('postgres_exporter_main') do
  it { should be_enabled }
  it { should be_running }
end

describe service('redis_exporter') do
  it { should be_enabled }
  it { should be_running }
end
