class puppetdashboard::githubinstall::rubygems inherits puppetdashboard {

  #$TMPDIR=generate('/bin/mktemp', '-d', '/tmp/install_rubygems.XXXXXXXXXX')
  $TMPDIR='/tmp'
  $PKG="rubygems-1.3.7"
  $URL="http://production.cf.rubygems.org/rubygems/${PKG}.tgz"
  $FETCHCMD="/usr/bin/wget -c -t10 -T20 -q ${URL}"
  $UNPACKCMD="/bin/tar xfz ${PKG}.tgz -C ${TMPDIR}"
  $INSTALLCMD='ruby setup.rb'
  $ALTERNATIVESCMD='/usr/sbin/update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.8 1'

  file { $TMPDIR:
    ensure => directory,
  }

  # install rubygems
  exec { $FETCHCMD:
    logoutput => true,
    user      => root,
    cwd       => $TMPDIR,
    onlyif    => "/usr/bin/test -w ${TMPDIR}",
    require   => File[$TMPDIR],
  }

  exec { $UNPACKCMD:
    logoutput => false,
    user      => root,
    cwd       => $TMPDIR,
    require   => Exec[$FETCHCMD],
  }

  notify { 'Setting up RubyGems for Puppet Dashboard..':
    require => Exec[$UNPACKCMD],
  }

  exec { $INSTALLCMD:
    logoutput => true,
    user      => root,
    cwd       => "${TMPDIR}/${PKG}",
    onlyif    => "/usr/bin/test -d ${TMPDIR}/${PKG}",
    require   => Exec[$UNPACKCMD],
  }


  # clean up
  file { "${TMPDIR}/${PKG}":
    ensure  => absent,
    force   => true,
    require => Exec[$INSTALLCMD],
  }
  file { "${TMPDIR}/${PKG}.tgz":
    ensure  => absent,
    force   => true,
    require => Exec[$INSTALLCMD],
  }

  case $osfamily {
    Debian: {
      exec { $ALTERNATIVESCMD:
        logoutput => true,
        user      => root,
        require   => Exec[$INSTALLCMD],
      }
    }
    default: { fail('Operating system not yet supported') }
  }

  notify { 'RubyGems for Puppet Dashboard successfully installed.':
    require => [ Exec[$INSTALLCMD], Exec[$ALTERNATIVESCMD] ],
  }
}

