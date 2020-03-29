directory '/etc/mysqld' do
  action :create
end

file '/etc/mysqld/my.cnf' do
  content 'user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
'
  action :create
end

user 'mysql' do
  comment 'Mock Mysql user'
  system true
end

mysqld_exporter 'main' do
  data_source_name '/'
  config_my_cnf '/etc/mysqld/my.cnf'
  user 'mysql'

  action %i(install enable start)
end
