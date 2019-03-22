Firewall {
  before  => Class['iptables::post'],
  require => Class['iptables::pre'],
}

node default {
  include role::reloadingdb
}
