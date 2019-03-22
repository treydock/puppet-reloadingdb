#
class role::reloadingdb {
  include profile::mysql
  include profile::rvm
}
