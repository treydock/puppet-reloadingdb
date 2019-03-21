#
class profile::rvm {
  include ::rvm
  
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
