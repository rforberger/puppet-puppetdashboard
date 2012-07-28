# Class puppetdashboard::rack
# 
# Manages rack on Puppet Dahsboard.
#
class puppetdashboard::rack inherits puppetdashboard {
  # package ressource type seems not capable to install specific versions using the gem provider

  package { $puppetdashboard::rubygems_package: ensure => installed, }

  exec { "gem install rack -v $puppetdashboard::rack_version":
    logoutput => true,
    require   => Package[$puppetdashboard::rubygems_package],
    onlyif    => "gem list rack -v ${version} && exit 1",
  }
}
