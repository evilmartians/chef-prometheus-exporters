default['prometheus_exporters']['node']['version'] = '1.0.0'
default['prometheus_exporters']['node']['url'] = "https://github.com/prometheus/node_exporter/releases/download/v#{node['prometheus_exporters']['node']['version']}/node_exporter-#{node['prometheus_exporters']['node']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['node']['checksum'] = 'fae88be0aa33c8ae22340723f9b4a4e519e67d2969da7a27751e755db7e75788'

default['prometheus_exporters']['node']['textfile_directory'] = '/var/lib/node_exporter/textfile_collector'

default['prometheus_exporters']['node']['ignored_net_devs'] = '^(weave|veth.*|docker0|datapath|dummy0)$'

default['prometheus_exporters']['node']['ignored_mount_points'] = '^/(sys|proc|dev|host|etc|var/lib/docker|run|var/lib/lxcfs|var/lib/kubelet)($|/)'

default['prometheus_exporters']['node']['collectors_enabled'] = %w(
  diskstats
  filefd
  filesystem
  interrupts
  loadavg
  mdadm
  meminfo
  netdev
  netstat
  sockstat
  stat
  tcpstat
  textfile
  time
  uname
  vmstat
)

default['prometheus_exporters']['node']['collectors_disabled'] = %w()
default['prometheus_exporters']['node']['port'] = 9100
default['prometheus_exporters']['node']['user'] = 'root'
