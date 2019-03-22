#
class role::reloadingdb {
  include profile::firewall
  include profile::mysql
  include profile::redis
  include profile::rvm
}
