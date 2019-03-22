#
class profile::mysql {

  include ::mysql::server
  include ::mysql::server::backup
  # mtime always changing
  #include ::mysql::server::mysqltuner
  include ::mysql::bindings
  include ::mysql::client

}
