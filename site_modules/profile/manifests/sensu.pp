#
class profile::sensu {
  include ::sensu::backend
  include ::sensu::agent
  include ::sensu::plugins
}
