os_name = os.name
os_release = os.release.to_f

# Node exporter
describe port(9100) do
  it { should be_listening }
  its('processes') { should cmp(/^node_expo/) }
end

describe service('node_exporter') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

# Redis exporter
describe port(9121) do
  it { should be_listening }
  its('processes') { should cmp(/^redis_expo/) }
end

describe service('redis_exporter') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

# Postgres exporter
describe port(9187) do
  it { should be_listening }
  its('processes') { should cmp(/^postgres_expo/) }
end

describe service('postgres_exporter_main') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

describe port(9188) do
  it { should be_listening }
  its('processes') { should cmp(/^postgres_expo/) }
end

describe service('postgres_exporter_chef') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

describe processes('postgres_exporter') do
  its('users') { should eq ['postgres', 'opscode-pgsql'] }
end

# SNMP exporter

describe port(9116) do
  it { should be_listening }
  its('processes') { should cmp(/^snmp_expo/) }
end

describe service('snmp_exporter') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end
