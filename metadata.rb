name             'prometheus_exporters'
maintainer       'Evil Martians'
maintainer_email 'surrender@evilmartians.com'
license          'All rights reserved'
description      'Installs/Configures Prometheus Exporters'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.9'

supports 'ubuntu'
supports 'centos', '>= 6.9'

depends 'systemd'
