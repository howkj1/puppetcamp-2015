node /^web/ {
  notify{"This is a web server in the ${::environment} environment": }

  $web_content = hiera('web_content')
  file{"/var/www/html/index.html":
    ensure => file,
    content => $web_content,
  }

}
