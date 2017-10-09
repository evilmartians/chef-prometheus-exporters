default['prometheus_exporters']['node']['version'] = '0.15.0'
default['prometheus_exporters']['node']['url'] = "https://github.com/prometheus/node_exporter/releases/download/v#{node['prometheus_exporters']['node']['version']}/node_exporter-#{node['prometheus_exporters']['node']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['node']['checksum'] = '9413b3c94dbe9d4341ce85ea7e3f0e20abb8804135b8c236c4440c2c841551d7'

default['prometheus_exporters']['node']['textfile_directory'] = '/var/lib/node_exporter/textfile_collector'

default['prometheus_exporters']['node']['ignored_net_devs'] = '^(veth.*|docker0|datapath|dummy0)$'

default['prometheus_exporters']['node']['ignored_mount_points'] = '^/(sys|proc|dev|host|etc|var/lib/docker|run|var/lib/lxcfs|var/lib/kubelet)($|/)'

default['prometheus_exporters']['node']['collectors_enabled'] = %w(
  conntrack
  cpu
  diskstats
  filefd
  filesystem
  interrupts
  loadavg
  mdadm
  meminfo
  mountstats
  netdev
  netstat
  ntp
  sockstat
  stat
  tcpstat
  textfile
  time
  uname
  vmstat
)

default['prometheus_exporters']['node']['collectors_disabled'] = %w()
