class web::install {
  package { 'nginx' :
    ensure => installed
  }
}
