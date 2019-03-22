#
class profile::rvm {
  package { 'curl': ensure => 'installed' }

  class { '::rvm':
    gnupg_key_id => false,
  }

  exec { 'import_rvm_key':
    path    => '/usr/bin:/bin',
    command => 'curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -',
    unless  => 'gpg --fingerprint | grep D39DC0E3',
  }

  exec { 'import_rvm_key2':
    path    => '/usr/bin:/bin',
    command => 'curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -',
    unless  => 'gpg --fingerprint | grep 39499BDB',
  }

  Package['curl']
  ->Exec['import_rvm_key']
  ->Exec['import_rvm_key2']
  ->Class['::rvm']

  rvm_system_ruby { 'ruby-2.5.1':
    ensure      => 'present',
    default_use => false,
  }
  rvm_gemset { 'ruby-2.5.1@reloadingdb-staging':
    ensure    => 'present',
    require => Rvm_system_ruby['ruby-2.5.1'],
  }
  rvm_gemset { 'ruby-2.5.1@reloadingdb':
    ensure    => 'present',
    require => Rvm_system_ruby['ruby-2.5.1'],
  }
  rvm_gem { 'ruby-2.5.1@reloadingdb-staging/bundler':
    ensure  => '2.0.1',
    require => Rvm_gemset['ruby-2.5.1@reloadingdb-staging']
  }
  rvm_gem { 'ruby-2.5.1@reloadingdb/bundler':
    ensure  => '2.0.1',
    require => Rvm_gemset['ruby-2.5.1@reloadingdb']
  }
}
