#
class profile::selinux {

  class { '::selinux':
    mode => 'enforcing',
    type => 'targeted',
  }

  selboolean { 'httpd_can_network_connect':
    persistent => true,
    value      => 'on',
  }
  selboolean { 'httpd_can_network_relay':
    persistent => true,
    value      => 'on',
  }

}
