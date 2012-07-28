class puppetdashboard::githubinstall inherits puppetdashboard {

  package { $github_os_packages: ensure => installed }

  include puppetdashboard::githubinstall::rubygems
  include puppetdashboard::githubinstall::dashboard



}
