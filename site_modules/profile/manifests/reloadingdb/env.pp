#
define profile::reloadingdb::env (
  String $webhost = 'reloadingdb.com',
  Integer $uid = 1002,
  Hash $ssh_authorized_keys = {},
) {

  $user = "reloadingdb-${name}"
  $approot = "/var/www/${webhost}"

  user { $user:
    ensure         => 'present',
    shell          => '/bin/bash',
    uid            => $uid,
    gid            => $user,
    comment        => "ReloadingDB ${name} User",
    home           => "/home/${user}",
    managehome     => false,
    purge_ssh_keys => true,
  }
  group { $user:
    ensure => 'present',
    gid    => $uid,
  }
  file { "/home/${user}":
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0700',
  }
  file { "/home/${user}/.ssh":
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0700',
  }
  file { "/home/${user}/.ssh/authorized_keys":
    ensure => 'file',
    owner  => $user,
    group  => $user,
    mode   => '0600',
  }
  rvm::system_user { $user:
    create => false,
  }
  $ssh_authorized_keys.each |$name, $key| {
    ssh_authorized_key { "${user}-${name}":
      ensure => 'present',
      user   => $user,
      *      => $key,
    }
  }

  exec { "mkdir -p ${approot}":
    path    => '/usr/bin:/bin',
    creates => $approot,
    before  => File[$approot],
  }
  file { $approot:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
