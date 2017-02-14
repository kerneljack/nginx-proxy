class web::config {
  file { '/var/www/html/index.html': 
    ensure => file,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/web/index.html',
  }
}
