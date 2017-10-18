# prometheus_exporters

# 0.4.0

- [Viktor Radnai] - Merged changes from Matt Mencel's repo (https://github.com/WIU/chef-prometheus-exporters.git)
- [Matt Mencel] - CentOS Support: updated only_if and not_if in node_exporter service
- [Matt Mencel] - Chef Warnings: Fixed Chef warnings in upstart template

## 0.3.0

- [Kirill Kuznetsov] - node_exporter version bump: `0.15.0`
- [Kirill Kuznetsov] - BREAKING: the new cmd syntax brings the need for a new resource properties.

## 0.2.1

- [Kirill Kuznetsov] - enable weave network interface monitoring by default to alert on its stauts.
- [Kirill Kuznetsov] - it now depends on `systemd` cookbook in general

## 0.2.0

- [Kirill Kuznetsov] - new systemd cookbook with new lwrp syntax
- [Kirill Kuznetsov] - new `redis_exporter` resource to install redis_exporter.
- [Kirill Kuznetsov] - set correct mode for postgres_exporter executable
- [Kirill Kuznetsov] - surround attributes for postgresql exporter in quotes.

## 0.1.2

- [Kirill Kuznetsov] - PostgreSQL Exporter resource.
- [Kirill Kuznetsov] - more options for upstart service template: env & setuid.
- [Kirill Kuznetsov] - default ignored mount points for Node Exporter.

## 0.1.0
- [Kirill Kuznetsov] - Initial release with `node_exporter` support.
