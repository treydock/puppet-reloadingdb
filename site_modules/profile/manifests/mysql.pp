#
class profile::mysql (
  Hash $databases = {},
  Hash $users = {},
) {

  include ::mysql::server
  include ::mysql::server::backup
  # mtime always changing
  #include ::mysql::server::mysqltuner
  include ::mysql::bindings
  include ::mysql::client

  create_resources('mysql::db', $databases)

  $users.each |$name, $user| {
    $password_hash = mysql_password($user['password'])
    $u = delete($user, 'password')
    mysql_user { $name:
      password_hash => $password_hash,
      *             => $u,
    }
  }

}
