# prometheus_exporters

## 0.12.1

- [Fatih Sarhan] - add Apache exporter to resource list in README

## 0.12.0

- [Fatih Sarhan] - resource list for README
- [Fatih Sarhan] - Apache exporter resource

## 0.11.1

- [Charles Rowe] - fix publication to supermarket.

## 0.11.0

- [Charles Rowe] - Add haproxy_exporter

## 0.10.1

- [Kirill Kuznetsov] - fix mysqld_exporter cmd for older systemd versions.
- [Kirill Kuznetsov] - add chefspec tests for `cookbook[testrig]`

## 0.10.0

- [Kirill Kuznetsov] - exporters update:
  - mysqld_exporter: `0.11.0`
  - node_exporter: `0.17.0`
  - postgres_exporter: `0.4.7`
  - redis_exporter: `0.22.1`
  - snmp_exporter: `0.13.0`
  - wmi_exporter: `0.5.0`

## 0.9.0

- [Viktor Radnai] - Add process_exporter

## 0.8.3

- [Edwin Mourant] - Smaill fix to initscript template

## 0.8.2

- [Viktor Radnai] - blackbox_exporter readme.

## 0.8.1

- [Kirill Kuznetsov] CHANGELOG update
- [Kirill Kuznetsov] RuboCop offences fix
- [Kirill Kuznetsov] Add 'enabled' attribute for wmi_exporter

## 0.8.0

- [Yousef Alam] - Add blackbox_exporter
- [Viktor Radnai] - Small fix to postgres_exporter binary's symlink


## 0.7.0

- [Kieren Scott] - Add mysqld_exporter
- [Matt Mencel] - Add wmi_exporter
- [Viktor Radnai] - Add 'enabled' attribute for using with Chef search
- [Viktor Radnai] - Fix: Remove unnecessary install step from redis exporter start action
- [Viktor Radnai] - Fix: quote environment variable values in init script

## 0.6.1

- [Kirill Kuznetsov] - fixed #7
- [Kirill Kuznetsov] - fixed exporter services naming; it's possible to install more than one copy of an exporter with a different service name
- [Denis C.] - node_exporter port attribute for `recipe[prometheus_exporters::node]`

## 0.6.0

- [Kirill Kuznetsov] - Chef 14 support was tested
- [Kirill Kuznetsov] - Ubuntu 18.04 support was tested
- [Kirill Kuznetsov] - Some Ubuntu 14 test were dropped because Chef 14 breakes the support of service creation on Ubuntu 14
- [Kirill Kuznetsov] - node_exporter version upgrade: 0.16.0
- [Kirill Kuznetsov] - postgres_exporter version upgrade: 0.4.6
- [Kirill Kuznetsov] - redis_exporter version upgrade: 0.18.0
- [Kirill Kuznetsov] - snmp_exporter version upgrade: 0.10.0
- [Kirill Kuznetsov] - New docker-based Kitchen & Travis CI configurations
- [Kirill Kuznetsov] - Conventional test configuration for Test Kitchen was updated

## 0.4.8

- [Kirill Kuznetsov] - postgres_exporter update: 0.4.2
- [Kirill Kuznetsov] - redis_exporter update: 0.15.0

## 0.4.7

- [Kirill Kuznetsov] - Travis CI integration for automated tests.

## 0.4.6

- [Kirill Kuznetsov] - node_exporter version upgrade: 0.15.2
- [Kirill Kuznetsov] - Forcing more RuboCop style fixes

## 0.4.5

- [Kirill Kuznetsov] - Bugfix redis_exporter systemd unit creation: untar should be done before systemd unit creation
- [Kirill Kuznetsov] - postgres_exporter version upgrade: 0.3.0
- [Kirill Kuznetsov] - redis_exporter version upgrade: 0.13
- [Kirill Kuznetsov] - snmp_exporter version upgrade: 0.8.0
- [Kirill Kuznetsov] - snmp_exporter's options now have two dashes instead of one
- [Kirill Kuznetsov] - Test cookbooks should be placed into `test/cookbooks` instead of `test/integration/cookbooks`
- [Kirill Kuznetsov] - Default InSpec test file was renamed to `deafult_spec.rb`
- [Kirill Kuznetsov] - Test Kitchen configuration: centos-6/7, ubuntu-14/16, chef-12/13
- [Kirill Kuznetsov] - README: node_exporter, redis_exporter, snmp_exporter sections were updated

## 0.4.2
- [Viktor Radnai] - Bugfix for starting redis process as the specified user

## 0.4.1

- [Viktor Radnai] - Split log directories to fix logfile permission issue when exporters aren't running as root
- [Viktor Radnai] - Bugfixes for postgres_exporter
- [Viktor Radnai] - Improvements for tests
- [Viktor Radnai] - Added checksum for SNMP exporter

## 0.4.0

- [Viktor Radnai] - Added tests
- [Viktor Radnai] - Improved service configuration for all exporters
- [Viktor Radnai] - Fixed errors reported by `cookstyle`
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

## 0.1.3

- [Matt Mencel] - CentOS Support: updated only_if and not_if in node_exporter service
- [Matt Mencel] - Chef Warnings: Fixed Chef warnings in upstart template

## 0.1.2

- [Kirill Kuznetsov] - PostgreSQL Exporter resource.
- [Kirill Kuznetsov] - more options for upstart service template: env & setuid.
- [Kirill Kuznetsov] - default ignored mount points for Node Exporter.

## 0.1.0
- [Kirill Kuznetsov] - Initial release with `node_exporter` support.
