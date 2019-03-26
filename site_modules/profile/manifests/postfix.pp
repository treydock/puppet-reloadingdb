#
class profile::postfix (
  Hash $configs = {},
) {
  include ::postfix
  create_resources('postfix::config', $configs)
}
