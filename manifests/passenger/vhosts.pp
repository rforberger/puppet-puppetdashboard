define puppetdashboard::passenger::vhosts ($listen_ip = $title, $af = 'inet') {
  # Vhost serving puppet dashboard via passenger
  apache::vhost { "${service_url}_${af}_ssl":
    enable => $puppetdashboard::passenger,
    port     => $puppetdashboard::port,
    docroot  => $puppetdashboard::install_root,
    template => 'puppetdashboard/apache-passenger-vhost.conf.erb',
  }

  # vhost serving on port 80 which rewrites everything to the dashboard serving vhost using HTTPS
  apache::vhost { "${service_url}_${af}":
    enable    => $puppetdashboard::passenger,
    template  => 'puppetdashboard/apache-rewrite-vhost.conf.erb',
  }
}

