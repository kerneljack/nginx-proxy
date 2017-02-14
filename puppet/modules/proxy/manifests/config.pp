class proxy::config {
  file { '/etc/nginx/sites-available/default': 
    ensure => file,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/proxy/default',
  }

  file { '/etc/nginx/nginx.conf': 
    ensure => file,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/proxy/nginx.conf',
  }

}
