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


  $motd = '/etc/update-motd.d/99-footer'
  concat { $motd:
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }
  concat::fragment{ 'motd_header':
    target  => $motd,
    content => "printf ''\n*** Puppet Environment: ${::environment}\n\n'",
    order   => '01'
  }

  $motd_content = hiera('motd_content')
  if $motd_content != nil {
    concat::fragment{ 'motd_content':
      target  => $motd,
      content => "echo '${motd_content}' | /usr/games/cowsay -n",
      order   => '02',
      require => Package['cowsay']
    }
  }



  package { 'links':
    ensure => '2.8-1ubuntu1',
  }

  package { 'cowsay':
    ensure => '3.03+dfsg1-6',
  }


}
