#
class profile::apache (

) {

  include ::letsencrypt
  include ::apache
  include ::apache::mod::headers
  include ::apache::mod::mime
  include ::apache::mod::proxy

  apache::vhost { 'default-http':
    vhost_name     => '_default_',
    servername     => false,
    port           => 80,
    manage_docroot => false,
    docroot        => '/var/www/html',
    priority       => 15,
    rewrites       => [
      {
        rewrite_cond => ['%{HTTPS} off'],
        rewrite_rule => ['(.*) https://%{HTTP_HOST}%{REQUEST_URI}'],
      },
    ],
  }

}
