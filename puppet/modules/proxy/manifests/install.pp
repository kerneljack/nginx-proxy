class proxy::install {
  package { 'nginx' :
    ensure => installed
  }
}
