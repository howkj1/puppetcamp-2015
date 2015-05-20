node /^web/ {
  notify{"This is a web server in the ${::environment} environment": }
}
