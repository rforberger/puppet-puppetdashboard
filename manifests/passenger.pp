class puppetdashboard::passenger () {

  require apache

  # ensure installed passenger packages
  package { $passenger_package_name: ensure => installed, }

}