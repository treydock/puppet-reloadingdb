#
class profile::firewall (
  Array $allow_ssh = [],
  Array $allow_apache = [],
  Hash $rules = {},
) {

  include ::firewall
  include ::iptables

  create_resources('firewall', $rules)

  $allow_ssh.each |$address| {
    firewall { "00022 ${address}:ssh":
      ensure => 'present',
      proto  => 'tcp',
      dport  => '22',
      source => $address,
      action => 'accept',
    }
  }

  $allow_apache.each |$address| {
    firewall { "00080 ${address}:http":
      ensure => 'present',
      proto  => 'tcp',
      dport  => '80',
      source => $address,
      action => 'accept',
    }
    firewall { "00443 ${address}:https":
      ensure => 'present',
      proto  => 'tcp',
      dport  => '443',
      source => $address,
      action => 'accept',
    }
  }

  if $facts['is_vagrant'] {
    firewall { "00022 *:ssh":
      ensure => 'present',
      proto  => 'tcp',
      dport  => '22',
      action => 'accept',
    }
  }

}
