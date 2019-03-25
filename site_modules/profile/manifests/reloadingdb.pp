#
class profile::reloadingdb (
  Hash $ssh_authorized_keys = {},
  Array $admin_emails = [],
){

  profile::reloadingdb::env { 'staging':
    webhost             => 'staging.reloadingdb.com',
    uid                 => 1001,
    ssh_authorized_keys => $ssh_authorized_keys,
    admin_emails        => $admin_emails,
    gemset              => 'ruby-2.5.1@reloadingdb-staging',
  }
  

}
