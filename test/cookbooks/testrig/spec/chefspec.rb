require 'chefspec'
require 'chefspec/berkshelf'

describe 'testrig::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04')
                        .converge(described_recipe)
  end

  it 'installs, enables and starts apache_exporter' do
    expect(chef_run).to install_apache_exporter('main')
    expect(chef_run).to enable_apache_exporter('main')
    expect(chef_run).to start_apache_exporter('main')
  end

  blackbox_exporter_properties = {
    web_listen_address: '0.0.0.0:9115',
    timeout_offset: '0.5',
    log_level: 'info',
  }

  it 'installs, enables and starts blackbox_exporter' do
    expect(chef_run).to install_blackbox_exporter('main')
      .with(blackbox_exporter_properties)
    expect(chef_run).to enable_blackbox_exporter('main')
      .with(blackbox_exporter_properties)
    expect(chef_run).to start_blackbox_exporter('main')
      .with(blackbox_exporter_properties)
  end

  it 'installs, enables and starts consul_exporter' do
    expect(chef_run).to install_consul_exporter('main')
    expect(chef_run).to enable_consul_exporter('main')
    expect(chef_run).to start_consul_exporter('main')
  end

  it 'installs, enables and starts elasticsearch_exporter' do
    expect(chef_run).to install_elasticsearch_exporter('main')
    expect(chef_run).to enable_elasticsearch_exporter('main')
    expect(chef_run).to start_elasticsearch_exporter('main')
  end

  it 'installs, enables and starts haproxy_exporter' do
    expect(chef_run).to install_haproxy_exporter('main')
    expect(chef_run).to enable_haproxy_exporter('main')
    expect(chef_run).to start_haproxy_exporter('main')
  end

  it 'installs, enables and starts mongodb_exporter' do
    expect(chef_run).to install_mongodb_exporter('main')
    expect(chef_run).to enable_mongodb_exporter('main')
    expect(chef_run).to start_mongodb_exporter('main')
  end

  mysqld_exporter_properties = {
    data_source_name: '/',
    config_my_cnf: '/etc/mysqld/my.cnf',
    user: 'mysql',
  }

  it 'installs, enables and starts mysqld_exporter' do
    expect(chef_run).to install_mysqld_exporter('main')
      .with(mysqld_exporter_properties)
    expect(chef_run).to enable_mysqld_exporter('main')
      .with(mysqld_exporter_properties)
    expect(chef_run).to start_mysqld_exporter('main')
      .with(mysqld_exporter_properties)
  end

  it 'installs, enables and starts first node_exporter' do
    expect(chef_run).to install_node_exporter('first')
    expect(chef_run).to enable_node_exporter('first')
    expect(chef_run).to start_node_exporter('first')
  end

  node_exporter_properties = {
    web_listen_address: ':9110',
  }

  it 'installs, enables and starts second node_exporter' do
    expect(chef_run).to install_node_exporter('second')
      .with(node_exporter_properties)
    expect(chef_run).to enable_node_exporter('second')
      .with(node_exporter_properties)
    expect(chef_run).to start_node_exporter('second')
      .with(node_exporter_properties)
  end

  it 'installs, enables and starts first postgres_exporter' do
    expect(chef_run).to install_postgres_exporter('main')
      .with(data_source_name: 'postgres')
    expect(chef_run).to enable_postgres_exporter('main')
      .with(data_source_name: 'postgres')
    expect(chef_run).to start_postgres_exporter('main')
      .with(data_source_name: 'postgres')
  end

  postgres_exporter_properties = {
    web_listen_address: '0.0.0.0:9188',
    data_source_name: 'user=opscode-pgsql host=/tmp/ sslmode=disable',
    user: 'opscode-pgsql',
  }

  it 'installs, enables and starts second postgres_exporter' do
    expect(chef_run).to install_postgres_exporter('chef')
      .with(postgres_exporter_properties)
    expect(chef_run).to enable_postgres_exporter('chef')
      .with(postgres_exporter_properties)
    expect(chef_run).to start_postgres_exporter('chef')
      .with(postgres_exporter_properties)
  end

  it 'installs, enables and starts process_exporter' do
    expect(chef_run).to install_process_exporter('main')
    expect(chef_run).to enable_process_exporter('main')
  end

  it 'installs, enables and starts rabbitmq_exporter' do
    expect(chef_run).to install_rabbitmq_exporter('main')
    expect(chef_run).to enable_rabbitmq_exporter('main')
    expect(chef_run).to start_rabbitmq_exporter('main')
  end

  it 'installs, enables and starts redis_exporter' do
    expect(chef_run).to install_redis_exporter('main')
    expect(chef_run).to enable_redis_exporter('main')
    expect(chef_run).to start_redis_exporter('main')
  end

  it 'installs, enables and starts snmp_exporter' do
    expect(chef_run).to install_snmp_exporter('main')
    expect(chef_run).to enable_snmp_exporter('main')
    expect(chef_run).to start_snmp_exporter('main')
  end

  it 'installs, enables and starts statsd_exporter' do
    expect(chef_run).to install_statsd_exporter('main')
    expect(chef_run).to enable_statsd_exporter('main')
    expect(chef_run).to start_statsd_exporter('main')
  end

  it 'installs, enables and starts varnish_exporter' do
    expect(chef_run).to install_varnish_exporter('main')
    expect(chef_run).to enable_varnish_exporter('main')
    expect(chef_run).to start_varnish_exporter('main')
  end
end
