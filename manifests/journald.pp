class systemd::journald(
  $compress = true,
  $forward_to_console = false,
  $forward_to_kmsg = false,
  $forward_to_syslog = true,
  $forward_to_wall = true,
  $max_file_sec = '1month',
  $max_level_console = 'info',
  $max_level_kmsg = 'notice',
  $max_level_store = 'debug',
  $max_level_syslog = 'debug',
  $max_level_wall = 'emerg',
  $max_retention_sec = undef,
  $rate_limit_burst = 1000,
  $rate_limit_interval = '30s',
  $runtime_keep_free = undef,
  $runtime_max_files_ize = undef,
  $runtime_max_use = undef,
  $seal = true,
  $split_mode = 'uid',
  $storage = 'auto',
  $sync_interval_sec = '5m',
  $system_keep_free = undef,
  $system_max_file_size = undef,
  $system_max_use = undef,
  $tty_path = '/dev/console'
) inherits systemd {

  validate_bool($compress, $forward_to_console, $forward_to_kmsg,
                $forward_to_syslog, $forward_to_wall, $seal)

  validate_integer($rate_limit_burst)

  validate_re($max_level_console, ['^emerg$', '^alert$', '^crit$', '^err$',
    '^warning$', '^notice$', '^info$', '^debug$'])

  validate_re($max_level_kmsg, ['^emerg$', '^alert$', '^crit$', '^err$',
    '^warning$', '^notice$', '^info$', '^debug$'])

  validate_re($max_level_store, ['^emerg$', '^alert$', '^crit$', '^err$',
    '^warning$', '^notice$', '^info$', '^debug$'])

  validate_re($max_level_syslog, ['^emerg$', '^alert$', '^crit$', '^err$',
    '^warning$', '^notice$', '^info$', '^debug$'])

  validate_re($max_level_wall, ['^emerg$', '^alert$', '^crit$', '^err$',
    '^warning$', '^notice$', '^info$', '^debug$'])

  file { '/etc/systemd/journald.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/journald.erb"),
    notify  => Exec['restart-systemd-journald'],
  }

  exec { 'restart-systemd-journald':
    command     => 'systemctl restart systemd-journald.service',
    refreshonly => true,
  }

}
