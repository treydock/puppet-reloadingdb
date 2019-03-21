#
class profile::reloadingdb::staging {

  user { 'reloadingdb-staging':
    ensure      => 'present',
    shell       => '/bin/bash',
    gid         => 'reloadingdb-staging',
    comment     => 'ReloadingDB Staging User',
    home        => '/home/reloadingdb-staging',
    managehome  => false,
  }
  group { 'reloading-staging':
    ensure => 'present',
  }
  file { '/home/reloadingdb-staging':
    ensure => 'directory',
    owner  => 'reloadingdb-staging',
    group  => 'reloadingdb-staging',
    mode   => '0700',
  }
  rvm::system_user { 'reloadingdb-staging': }

}
