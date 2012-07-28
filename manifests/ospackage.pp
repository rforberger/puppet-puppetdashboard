class puppetdashboard::ospackage inherits puppetdashboard {
  ### Managed resources
  package { 'puppetdashboard':
    ensure => $puppetdashboard::manage_package,
    name   => $puppetdashboard::package,
    notify => Exec['puppetdashboard_dbmigrate'],
  }

  service { 'puppetdashboard':
    ensure     => $puppetdashboard::manage_service_ensure,
    name       => $puppetdashboard::service,
    enable     => $puppetdashboard::manage_service_enable,
    hasstatus  => $puppetdashboard::service_status,
    pattern    => $puppetdashboard::process,
    require    => [ Package['puppetdashboard'] , Class['puppetdashboard::mysql'] ],
  }

  service { 'puppetdashboard-workers':
    ensure     => $puppetdashboard::manage_service_ensure,
    name       => $puppetdashboard::service_workers,
    enable     => $puppetdashboard::manage_service_enable,
    hasstatus  => $puppetdashboard::service_status,
    pattern    => $puppetdashboard::process,
    require    => [ Package['puppetdashboard'] , Class['puppetdashboard::mysql'] ],
  }
 }