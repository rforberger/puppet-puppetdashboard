class puppetdashboard::githubinstall::dashboard inherits puppetdashboard {

  # compile comands
  $DASHBOARD_URL='https://github.com/puppetlabs/puppet-dashboard.git'
  $CLONE_CMD="/usr/bin/git clone ${DASHBOARD_URL} ${puppetdashboard::install_root}"

  $CHECKOUT_CMD="/usr/bin/git checkout ${puppetdashboard::dashboard_version}"
  $BRANCH='production'
  $NEWBRANCH_CMD="/usr/bin/git checkout -b ${BRANCH}"
  $SWITCH_BRANCH_CMD="/usr/bin/git checkout ${BRANCH}"

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
    unless    => "/usr/bin/git describe | grep ${puppetdashboard::dashboard_version} >/dev/null",
    require   => Exec[$CLONE_CMD],
  }

  exec { $NEWBRANCH_CMD:
    logoutput => true,
    user      => $owner,
    group     => $group,
    cwd       => $puppetdashboard::install_root,
    unless    => "/usr/bin/git branch | grep ${BRANCH} >/dev/null",
    require   => Exec[$CHECKOUT_CMD],
  }

  exec { $SWITCH_BRANCH_CMD:
    logoutput => true,
    user      => $owner,
    group     => $group,
    cwd       => $puppetdashboard::install_root,
    onlyif    => "/usr/bin/git branch | grep 'no branch' >/dev/null",
    unless    => "/usr/bin/git branch | egrep '^* ${BRANCH}' >/dev/null",
    require   => Exec[$CHECKOUT_CMD],
  }


}

