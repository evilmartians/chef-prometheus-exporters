name             'prometheus_exporters'
maintainer       'Evil Martians'
maintainer_email 'surrender@evilmartians.com'
license          'Apache-2.0'
description      'Installs / configures Prometheus exporters'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version          '0.15.7'

chef_version '>= 12.14', '< 16.0'

supports 'amazon'
supports 'centos', '>= 6.9'
supports 'debian', '>= 8.0'
supports 'fedora', '>= 28.0'
supports 'oracle'
supports 'scientific'
supports 'ubuntu', '>= 14.04'
supports 'windows'

issues_url 'https://github.com/evilmartians/chef-prometheus-exporters/issues'
source_url 'https://github.com/evilmartians/chef-prometheus-exporters/'
