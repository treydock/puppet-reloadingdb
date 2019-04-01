#
class profile::postfix (
  Hash $configs = {},
  String $username = 'changeme',
  String $password = 'changeme',
) {

  package { ['cyrus-sasl','cyrus-sasl-lib','cyrus-sasl-plain']:
    ensure => 'installed',
    before => Class['::postfix'],
  }

  include ::postfix
  create_resources('postfix::config', $configs)

  postfix::hash { '/etc/postfix/sasl_passwd':
    ensure  => 'present',
    content => "${::postfix::relayhost} ${username}:${password}\n"
  }
  postfix::hash { '/etc/postfix/generic':
    ensure  => 'present',
    content => "@${::postfix::myorigin} no-reply+reloadingdb@${::postfix::myorigin}\n",
  }
}
