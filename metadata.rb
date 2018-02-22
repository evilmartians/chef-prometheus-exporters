name             'prometheus_exporters'
maintainer       'Evil Martians'
maintainer_email 'surrender@evilmartians.com'
license          'Apache-2.0'
description      'Installs / configures Prometheus exporters'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.8'

chef_version '>= 12.14', '< 14.0'

supports 'ubuntu'
supports 'centos', '>= 6.9'

issues_url 'https://github.com/evilmartians/chef-prometheus-exporters/issues'
source_url 'https://github.com/evilmartians/chef-prometheus-exporters/'
