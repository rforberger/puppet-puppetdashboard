class puppetdashboard::passenger () inherits puppetdashboard {

  include apache::passenger

  # roll out the ssl files
  file { $puppetdashboard::sslcrt:
    ensure => present,
    source => $puppetdashboard::file_src_sslcrt,
    mode   => '0600'
  }
  file { $puppetdashboard::sslkey:
    ensure => present,
    source => $puppetdashboard::file_src_sslkey,
    mode   => '0600'
  }
  if $puppetdashboard::file_src_sslcrl != undef {
    file { $puppetdashboard::sslcrl:
      ensure => present,
      source => $puppetdashboard::file_src_sslcrl,
      mode   => '0600'
    }
  }
  if $puppetdashboard::file_src_sslca != undef {
    file { $puppetdashboard::sslca:
      ensure => present,
      source => $puppetdashboard::file_src_sslca,
      mode   => '0600'
    }
  }

  case $::operatingsystem {
    /(?i:Debian|Ubuntu|Mint)/: {
      file { '/etc/apache2/conf.d/puppetdashboard-ports.conf':
        ensure  => present,
        content => template('puppetdashboard/puppetdashboard-apache-ports.conf.erb'),
      }
    }
    default: { fail('Operating system not yet supported.') }
  }

  if $listen_ip4 != undef {
    puppetdashboard::passenger::vhosts { $listen_ip4: af => 'inet', }
  }

  if $listen_ip6 != undef {
    puppetdashboard::passenger::vhosts { $listen_ip6: af => 'inet6', }
  }

}

