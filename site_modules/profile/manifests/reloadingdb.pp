#
class profile::reloadingdb (
  Hash $ssh_authorized_keys = {}
){

  profile::reloadingdb::env { 'staging':
    webhost             => 'staging.reloadingdb.com',
    uid                 => 1001,
    ssh_authorized_keys => $ssh_authorized_keys,
  }
  

}
