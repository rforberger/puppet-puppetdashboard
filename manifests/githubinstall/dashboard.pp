class puppetdashboard::githubinstall::dashboard inherits puppetdashboard {

  # compile comands
  $DASHBOARD_URL='https://github.com/puppetlabs/puppet-dashboard.git'
  $CLONE_CMD="/usr/bin/git clone ${DASHBOARD_URL} ${puppetdashboard::install_root}"

  $CHECKOUT_CMD="/usr/bin/git checkout ${puppetdashboard::dashboard_version}"
  $NEWBRANCH_CMD="/usr/bin/git checkout -b production"

  case $osfamily {
    Debian: {
      package { 'git': ensure => installed }
      $owner = 'www-data'
      $group = 'www-data'
    }
    default: { fail('Operating system not yet supported') }
  }

  file { $puppetdashboard::install_root:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0750',
  }

  exec { $CLONE_CMD:
    logoutput => true,
    user      => $owner,
    group     => $group,
    require   => File[$puppetdashboard::install_root],
    onlyif    => "/usr/bin/test ! -d ${puppetdashboard::install_root}/.git",
  }

  exec { $CHECKOUT_CMD:
    logoutput => true,
    user      => $owner,
    group     => $group,
    cwd       => $puppetdashboard::install_root,
    require   => Exec[$CLONE_CMD],
  }

  exec { $NEWBRANCH_CMD:
    logoutput => true,
    user      => $owner,
    group     => $group,
    cwd       => $puppetdashboard::install_root,
    require   => Exec[$CHECKOUT_CMD],
  }

}

