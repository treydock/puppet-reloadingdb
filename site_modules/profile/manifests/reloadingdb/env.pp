#
define profile::reloadingdb::env (
  String $webhost = 'reloadingdb.com',
  Integer $port = 9292,
  Integer $uid = 1002,
  Hash $ssh_authorized_keys = {},
  Array $admin_emails = [],
  String $gemset = 'ruby-2.5.1@reloadingdb',
) {

  $user = "reloadingdb-${name}"
  $approot = "/var/www/${webhost}"
  $master_key = lookup('reloadingdb_master_key')

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
  mailalias { $user:
    ensure    => 'present',
    recipient => $admin_emails,
    notify    => Exec['newaliases'],
  }

  exec { "mkdir -p ${approot}":
    path    => '/usr/bin:/bin',
    creates => $approot,
    before  => File[$approot],
  }
  file { $approot:
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  file { "${approot}/shared":
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  file { "${approot}/shared/config":
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  file { "${approot}/shared/config/master.key":
    ensure    => 'file',
    owner     => $user,
    group     => $user,
    mode      => '0600',
    content   => "${master_key}\n",
    show_diff => false,
  }

  $rvm = '/usr/local/rvm/bin/rvm'
  cron { 'puma':
    command => "cd ${approot}/current && ${rvm} ${gemset} do bundle exec puma -C ${approot}/shared/puma.rb --daemon 2>&1 | logger -t puma-${user}",
    user    => $user,
    special => 'reboot',
  }

  sensu_check { "puma-port-${name}":
    ensure        => 'present',
    command       => "/opt/sensu-plugins-ruby/embedded/bin/check-ports.rb -H 127.0.0.1 -p ${port}",
    subscriptions => ['all'],
    handlers      => ['email'],
    interval      => 300,
    publish       => true,
  }

  if $facts['virtual'] == 'virtualbox' {
    $ssl_cert = undef
    $ssl_chain = undef
    $ssl_key = undef
  } else {
    $ssl_cert = "/etc/letsencrypt/live/${webhost}/cert.pem"
    $ssl_chain = "/etc/letsencrypt/live/${webhost}/chain.pem"
    $ssl_key = "/etc/letsencrypt/live/${webhost}/privkey.pem"
  }

  apache::vhost { $webhost:
    servername  => $webhost,
    port        => '443',
    docroot     => "${approot}/current/public",
    ssl         => true,
    ssl_cert    => $ssl_cert,
    ssl_chain   => $ssl_chain,
    ssl_key     => $ssl_key,
    directories => [],
    no_proxy_uris => ['/assets', '/system'],
    proxy_dest => "http://127.0.0.1:${port}",
  }

}
