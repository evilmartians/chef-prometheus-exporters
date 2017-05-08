default['prometheus_exporters']['node']['version'] = '0.14.0'
default['prometheus_exporters']['node']['url'] = "https://github.com/prometheus/node_exporter/releases/download/v#{node['prometheus_exporters']['node']['version']}/node_exporter-#{node['prometheus_exporters']['node']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['node']['checksum'] = 'd5980bf5d0dc7214741b65d3771f08e6f8311c86531ae21c6ffec1d643549b2e'

default['prometheus_exporters']['node']['textfile_directory'] = '/var/lib/node_exporter/textfile_collector'

default['prometheus_exporters']['node']['ignored_net_devs'] = '^(weave|veth.*|docker0|datapath|dummy0)$'

default['prometheus_exporters']['node']['ignored_mount_points'] = '^/(sys|proc|dev|host|etc|var/lib/docker|run|var/lib/lxcfs|var/lib/kubelet)($|/)'

default['prometheus_exporters']['node']['collectors'] = %w(
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
