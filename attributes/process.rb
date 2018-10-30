default['prometheus_exporters']['process']['version'] = '0.4.0'
default['prometheus_exporters']['process']['url'] = "https://github.com/ncabatoff/process-exporter/releases/download/v#{node['prometheus_exporters']['process']['version']}/process-exporter-#{node['prometheus_exporters']['process']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['process']['checksum'] = '668b1b2c9069888ec36db0c2eb6edfd7509ca2f200f708c624d9c27fc9c5dfc1'
