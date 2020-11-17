def add_epel_7
  bash 'Add epel-release-latest-7' do
    code 'rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
    not_if 'rpm -qa | grep epel-release-7'
  end
end

def add_network_config
  file '/etc/sysconfig/network' do
    content 'NETWORKING=yes'
  end
end

case node['platform']
when 'amazon'
  add_epel_7
  add_network_config
when 'centos'
  case node['platform_version'].to_i
  when 7
    add_epel_7
    add_network_config
  end
end

package 'nginx'

file '/etc/nginx/conf.d/nginx-status.conf' do
  content 'server {
      listen 83;
      server_name localhost;
      location /nginx_status {
          stub_status on;
      }
  }'
end

service 'nginx' do
  action :start
end

nginx_exporter 'main' do
  action %i(install enable start)
end
