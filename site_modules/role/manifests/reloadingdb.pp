#
class role::reloadingdb {
  include profile::apache
  include profile::firewall
  include profile::mysql
  include profile::postfix
  include profile::redis
  include profile::reloadingdb
  include profile::root
  include profile::rvm
  include profile::ssh
}
