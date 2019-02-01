os_name = os.name
os_release = os.release.to_f

# Mysqld exporter
describe port(9104) do
  it { should be_listening }
  its('processes') { should cmp(/^mysqld_expo/) }
end

describe service('mysqld_exporter_main') do
  it { should be_enabled }
  it { should be_running }
end

# Node exporter
[9100, 9110].each do |node_exporter_port|
  describe port(node_exporter_port) do
    it { should be_listening }
    its('processes') { should cmp(/^node_expo/) }
  end
end

%w[
  first
  second
].each do |node_exporter_name|
  describe service("node_exporter_#{node_exporter_name}") do
    # Chef 14 resource service is broken on a first run on Ubuntu 14.
    it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
    it { should be_running }
  end
end

# Redis exporter
describe port(9121) do
  it { should be_listening }
  its('processes') { should cmp(/^redis_expo/) }
end

describe service('redis_exporter_main') do
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

describe service('snmp_exporter_main') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

# Blackbox exporter
describe port(9115) do
  it { should be_listening }
  its('processes') { should cmp(/^blackbox_expo/) }
end

describe service('blackbox_exporter_main') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

# Process exporter
describe port(9256) do
  it { should be_listening }
  its('processes') { should cmp(/^process_expo/) }
end

describe service('process_exporter_main') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

# HAProxy exporter
describe port(9101) do
  it { should be_listening }
  its('processes') { should cmp(/^haproxy_expo/) }
end

describe service('haproxy_exporter_main') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end

# Apache exporter
describe port(9117) do
  it { should be_listening }
  its('processes') { should cmp(/^apache_expo/) }
end

describe service('apache_exporter_main') do
  # Chef 14 resource service is broken on a first run on Ubuntu 14.
  it { should be_enabled } if os_name == 'ubuntu' and os_release > 14.04
  it { should be_running }
end
