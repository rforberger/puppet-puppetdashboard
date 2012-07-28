class puppetdashboard::githubinstall::rubygems inherits puppetdashboard {
  
  $PKG="rubygems-1.3.7.tgz"
  $URL="http://production.cf.rubygems.org/rubygems/${PKG}"
  $WGETCMD="/usr/bin/wget -c -t10 -T20 -q ${URL}"

  
  # install rubygems
  exec { $WGETCMD: 
    logoutput => true, 
    user      => root, 
    cwd       => '/tmp',
  }
  
  
}
