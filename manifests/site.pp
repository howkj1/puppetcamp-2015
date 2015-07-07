node /^web/ {

  class{'nginx':}

  nginx::resource::vhost { 'localhost':
    www_root => '/var/www/html',
  }

  notify{"This is a web server in the ${::environment} environment": }

  file{"/var/www/": ensure => directory} -> file{"/var/www/html": ensure => directory, }

  $web_content = hiera('web_content')
  file{"/var/www/html/index.html":
    ensure   => file,
    content  => $web_content,
    require  => [File["/var/www/html"]],
  }

  package { 'links':
    ensure => '2.8-1ubuntu1',
  }
}
