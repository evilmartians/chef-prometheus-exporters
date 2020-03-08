## TL;DR

To run standart tests for this code please run:

```shell
foodcritic -f any . \
&& cookstyle . \
&& rspec test/cookbooks/testrig/spec/chefspec.rb \
&& kitchen test
```
