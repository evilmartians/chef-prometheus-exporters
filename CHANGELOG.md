# prometheus\_exporters

## 0.17.2

- [Kirill Kuznetsov] Blackbox exporter 0.17.0

## 0.17.1

- [Kirill Kuznetsov] Fix cookstyle offences
- [Kirill Kuznetsov] Bundle update

## 0.17.0

- [Shai Atias] apache exporter 0.8.0
- [Kirill Kuznetsov] fixed bug with `--insecure` arg for apache exporter
- [Kirill Kuznetsov] mongodb exporter 0.11.0
- [Kirill Kuznetsov] node exporter 1.0.0
- [Kirill Kuznetsov] process exporter 0.6.0
- [Kirill Kuznetsov] redis exporter 1.6.1
- [Kirill Kuznetsov] snmp exporter 0.18.0
- [Kirill Kuznetsov] statsd exporter 0.16.0
- [Kirill Kuznetsov] wmi exporter 0.13.0
- [Kirill Kuznetsov] node exporter resource attributes update

## 0.16.3

- [Kirill Kuznetsov] set consul exporter health summary property to false by default

## 0.16.2

- [Sergei Makarevich] consul exporter 0.6.0
- [Kirill Kuznetsov] consul exporter resource refacotring
- [Kirill Kuznetsov] Ubuntu 20.04 test suites

## 0.16.1

- [Lior Tzur] rabbitmq_exporter 1.0.0-RC7
- [Lior Tzur] recipe[prometheus_exporters::rabbitmq] default publish address: ''

## 0.16.0

- [Lior Tzur] switch the rabbitmq expoerter back to ENV-var style configuration
- [Kirill Kuznetsov] update chefspec tests
- [Kirill Kuznetsov] add tests that rabbitmq accepts its configuration
- [Kirill Kuznetsov] TravisCI was switched to ruby 2.7.1

## 0.15.9

- [Kirill Kuznetsov] fix cookstyle bugs
- [Kirill Kuznetsov] fix rabbitmq systemd unit env variable

## 0.15.8

- [Lior Tzur] rabbitmq_exporter
- [Kirill Kuznetsov] rabbitmq_exporter resource refacotring
- [Kirill Kuznetsov] bundler update
- [Kirill Kuznetsov] testrig cookbook refacotring

## 0.15.7

- [Adam Kobi] elasticsearch_exporter
- [Adam Kobi] mongodb_exporter
- [Kirill Kuznetsov] README update & alphabetical sort
- [Kirill Kuznetsov] Chef 13 tests were dropped
- [Kirill Kuznetsov] Fedora 30/31 tests only
- [Kirill Kuznetsov] Ubuntu 14 support was dropped

## 0.15.6

- [Kirill Kuznetsov] varnish recipe fix

## 0.15.5

- [Stephan Scheying] initial varnish exporter support
- [Kirill Kuznetsov] full support for cmd line parameters for varnish exporter.

## 0.15.4

- [Kirill Kuznetsov] one more bundle update
- [Kirill Kuznetsov] fix travisci.yaml bundle preparation
- [Wolfgang Schnerring] postgres\_exporter `disable\_settings\_metrics` option support

## 0.15.3

- [Kirill Kuznetsov] - bundle update

## 0.15.2

- [Kirill Kuznetsov] - exporters update:
  - blackbox\_exporter - `0.16.0`
  - postgres\_exporter - `0.8.0`
  - redis\_exporter - `1.3.5`
  - snmp\_exporter - `0.16.1`
  - statsd\_exporter - `0.13.0`
  - wmi\_exporter - `0.9.0`
- [Kirill Kuznetsov] - TravisCI ruby 2.6.5

## 0.15.1

- [Kirill Kuznetsov] - dummy release to test TravisCI flow.

## 0.15.0

- [Kirill Kuznetsov] - exporters update:
  - apache\_exporter - `0.7.0`
  - blackbox\_exporter - `0.15.0`
  - mysqld\_exporter - `0.12.1`
  - node\_exporter - `0.18.1`
  - postgres\_exporter - `0.5.1`
  - redis\_exporter - `1.1.1`
  - statsd\_exporter - `0.12.2`
  - wmi\_exporter - `0.8.3`
- [Kirill Kuznetsov] - Test Kitchen & TravisCI now use Dokken for tests
- [Kirill Kuznetsov] - bundle update

## 0.14.1

- [Asher Yanich] Fix bad quoting on systemd\_unit\_whitelist and systemd\_unit\_blacklist resources.

## 0.14.0

*Breaking changes*:

If you want to use Redis exporter < `1.0.0` consider a version of this cookbook lower than `0.14.0`.

- [Brian Baker] - Redis exporter 1.0.0 installation support.
- [Kirill Kuznetsov] - Redis exporter 1.0.0 full support.
- [Kirill Kuznetsov] - exporters update:
  - redis\_exporter - `1.0.0`

## 0.13.1

- [Wolfgang Schnerring] - statsd\_exporter resource.

## 0.13.0

- [Kirill Kuznetsov] - fix #23
- [Kirill Kuznetsov] - exporters update:
  - blackbox\_exporter - `0.14.0`
  - haproxy\_exporter - `0.10.0`
  - node\_exporter - `0.18.0`
  - process\_exporter - `0.5.0`
  - redis\_exporter - `0.34.1`
  - snmp\_exporter - `0.15.0`
  - wmi\_exporter - `0.7.0`
- [Kirill Kuznetsov] - actualize properties for all resources and refactor their names a bit.
- [Kirill Kuznetsov] - Chef 15 tests and support.
- [Kirill Kuznetsov] - TravisCI ruby 2.6.3 & matrix update.

## 0.12.1

- [Fatih Sarhan] - add Apache exporter to resource list in README

## 0.12.0

- [Fatih Sarhan] - resource list for README
- [Fatih Sarhan] - Apache exporter resource

## 0.11.1

- [Charles Rowe] - fix publication to supermarket.

## 0.11.0

- [Charles Rowe] - Add haproxy\_exporter

## 0.10.1

- [Kirill Kuznetsov] - fix mysqld\_exporter cmd for older systemd versions.
- [Kirill Kuznetsov] - add chefspec tests for `cookbook[testrig]`

## 0.10.0

- [Kirill Kuznetsov] - exporters update:
  - mysqld\_exporter: `0.11.0`
  - node\_exporter: `0.17.0`
  - postgres\_exporter: `0.4.7`
  - redis\_exporter: `0.22.1`
  - snmp\_exporter: `0.13.0`
  - wmi\_exporter: `0.5.0`

## 0.9.0

- [Viktor Radnai] - Add process\_exporter

## 0.8.3

- [Edwin Mourant] - Smaill fix to initscript template

## 0.8.2

- [Viktor Radnai] - blackbox\_exporter readme.

## 0.8.1

- [Kirill Kuznetsov] CHANGELOG update
- [Kirill Kuznetsov] RuboCop offences fix
- [Kirill Kuznetsov] Add 'enabled' attribute for wmi\_exporter

## 0.8.0

- [Yousef Alam] - Add blackbox\_exporter
- [Viktor Radnai] - Small fix to postgres\_exporter binary's symlink


## 0.7.0

- [Kieren Scott] - Add mysqld\_exporter
- [Matt Mencel] - Add wmi\_exporter
- [Viktor Radnai] - Add 'enabled' attribute for using with Chef search
- [Viktor Radnai] - Fix: Remove unnecessary install step from redis exporter start action
- [Viktor Radnai] - Fix: quote environment variable values in init script

## 0.6.1

- [Kirill Kuznetsov] - fixed #7
- [Kirill Kuznetsov] - fixed exporter services naming; it's possible to install more than one copy of an exporter with a different service name
- [Denis C.] - node\_exporter port attribute for `recipe[prometheus_exporters::node]`

## 0.6.0

- [Kirill Kuznetsov] - Chef 14 support was tested
- [Kirill Kuznetsov] - Ubuntu 18.04 support was tested
- [Kirill Kuznetsov] - Some Ubuntu 14 test were dropped because Chef 14 breakes the support of service creation on Ubuntu 14
- [Kirill Kuznetsov] - node\_exporter version upgrade: 0.16.0
- [Kirill Kuznetsov] - postgres\_exporter version upgrade: 0.4.6
- [Kirill Kuznetsov] - redis\_exporter version upgrade: 0.18.0
- [Kirill Kuznetsov] - snmp\_exporter version upgrade: 0.10.0
- [Kirill Kuznetsov] - New docker-based Kitchen & Travis CI configurations
- [Kirill Kuznetsov] - Conventional test configuration for Test Kitchen was updated

## 0.4.8

- [Kirill Kuznetsov] - postgres\_exporter update: 0.4.2
- [Kirill Kuznetsov] - redis\_exporter update: 0.15.0

## 0.4.7

- [Kirill Kuznetsov] - Travis CI integration for automated tests.

## 0.4.6

- [Kirill Kuznetsov] - node\_exporter version upgrade: 0.15.2
- [Kirill Kuznetsov] - Forcing more RuboCop style fixes

## 0.4.5

- [Kirill Kuznetsov] - Bugfix redis\_exporter systemd unit creation: untar should be done before systemd unit creation
- [Kirill Kuznetsov] - postgres\_exporter version upgrade: 0.3.0
- [Kirill Kuznetsov] - redis\_exporter version upgrade: 0.13
- [Kirill Kuznetsov] - snmp\_exporter version upgrade: 0.8.0
- [Kirill Kuznetsov] - snmp\_exporter's options now have two dashes instead of one
- [Kirill Kuznetsov] - Test cookbooks should be placed into `test/cookbooks` instead of `test/integration/cookbooks`
- [Kirill Kuznetsov] - Default InSpec test file was renamed to `deafult_spec.rb`
- [Kirill Kuznetsov] - Test Kitchen configuration: centos-6/7, ubuntu-14/16, chef-12/13
- [Kirill Kuznetsov] - README: node\_exporter, redis\_exporter, snmp\_exporter sections were updated

## 0.4.2
- [Viktor Radnai] - Bugfix for starting redis process as the specified user

## 0.4.1

- [Viktor Radnai] - Split log directories to fix logfile permission issue when exporters aren't running as root
- [Viktor Radnai] - Bugfixes for postgres\_exporter
- [Viktor Radnai] - Improvements for tests
- [Viktor Radnai] - Added checksum for SNMP exporter

## 0.4.0

- [Viktor Radnai] - Added tests
- [Viktor Radnai] - Improved service configuration for all exporters
- [Viktor Radnai] - Fixed errors reported by `cookstyle`
- [Viktor Radnai] - Merged changes from Matt Mencel's repo (https://github.com/WIU/chef-prometheus-exporters.git)
- [Matt Mencel] - CentOS Support: updated only\_if and not\_if in node\_exporter service
- [Matt Mencel] - Chef Warnings: Fixed Chef warnings in upstart template

## 0.3.0

- [Kirill Kuznetsov] - node\_exporter version bump: `0.15.0`
- [Kirill Kuznetsov] - BREAKING: the new cmd syntax brings the need for a new resource properties.

## 0.2.1

- [Kirill Kuznetsov] - enable weave network interface monitoring by default to alert on its stauts.
- [Kirill Kuznetsov] - it now depends on `systemd` cookbook in general

## 0.2.0

- [Kirill Kuznetsov] - new systemd cookbook with new lwrp syntax
- [Kirill Kuznetsov] - new `redis_exporter` resource to install redis\_exporter.
- [Kirill Kuznetsov] - set correct mode for postgres\_exporter executable
- [Kirill Kuznetsov] - surround attributes for postgresql exporter in quotes.

## 0.1.3

- [Matt Mencel] - CentOS Support: updated only\_if and not\_if in node\_exporter service
- [Matt Mencel] - Chef Warnings: Fixed Chef warnings in upstart template

## 0.1.2

- [Kirill Kuznetsov] - PostgreSQL Exporter resource.
- [Kirill Kuznetsov] - more options for upstart service template: env & setuid.
- [Kirill Kuznetsov] - default ignored mount points for Node Exporter.

## 0.1.0
- [Kirill Kuznetsov] - Initial release with `node_exporter` support.
