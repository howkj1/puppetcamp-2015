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


  $motd = '/etc/motd'
  concat::fragment{ 'motd_header':
    target  => $motd,
    content => "\nEnvironment: ${::environment}:\n\n",
    order   => '01'
  }

  concat::fragment{ 'motd_content':
    target  => $motd,
    content => $motd_content,
    order   => '02'
  }



  package { 'links':
    ensure => '2.8-1ubuntu1',
  }
}
