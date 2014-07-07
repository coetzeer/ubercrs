include baseconfig

node 'rcs-common' {

}

node 'gitolite' {

}

node 'gitlab' {
  package { 'epel-release':
    source   => 'http://ftp.heanet.ie/pub/fedora/epel/6/i386/epel-release-6-8.noarch.rpm',
    ensure   => installed,
    provider => 'rpm',
  } ->
  package { 'ruby-devel': } ->
  class { 'gitlab':
    git_email          => 'notifs@gitlab.coetzee.com',
    git_comment        => 'Raymonds GitLab',
    gitlab_domain      => 'gitlab.coetzee.com',
    #    gitlab_dbtype => 'pgsql',
    #    gitlab_dbname => 'gitlab',
    #    gitlab_dbuser => 'gitlab',
    #    gitlab_dbpwd  => 'gitlab',
    gitlabshell_branch => 'v1.9.6',
    gitlab_branch      => '7-0-stable',
    ldap_enabled       => false,
  }

}

node 'gitorious' {

}

node 'reviewboard' {

}

node 'cvs' {

}

node 'svn' {

}

node 'bzr' {

}

node 'pf' {

}


node 'hg' {
  class { 'mysql::server':
    root_password    => 'blossom',
    override_options => {
      'mysqld' => {
        'sql_mode' => 'STRICT_ALL_TABLES'
      }
    }
  }

  ini_setting { "php_ini":
    ensure  => present,
    path    => '/etc/php.ini',
    section => 'Date',
    setting => 'date.timezone',
    value   => 'Europe/Dublin',
    notify  => Service['httpd']
  }

  class { 'mercurial':
  }

  # ini_setting { "php_ini_apc":
  #    ensure  => present,
  #    path    => '/etc/php.ini',
  #    section => 'PHP',
  #    setting => 'apc.stat',
  #    value   => '0',
  #  }

  class { 'apache':
    default_vhost => false,
  }

  class { 'apache::mod::ssl':
  }

  class { 'apache::mod::php':
  }

  apache::vhost { $fqdn:
    port     => '80',
    docroot  => '/usr/share/phabricator/phabricator/webroot',
    rewrites => [{
        rewrite_rule => ['^/rsrc/(.*)     -                       [L,QSA]'],
        rewrite_rule => ['^/favicon.ico   -                       [L,QSA]'],
        rewrite_rule => ['^(.*)$          /index.php?__path__=$1  [B,L,QSA]']
      }
      ]
  }

  exec { 'set_mysql_host':
    command => 'config set mysql.host localhost',
    path    => '/usr/share/phabricator/phabricator/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    cwd     => '/usr/share/phabricator/phabricator',
    notify  => Service['httpd']
  } ->
  exec { 'set_mysql_user':
    command => 'config set mysql.user root',
    path    => '/usr/share/phabricator/phabricator/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    cwd     => '/usr/share/phabricator/phabricator',
    notify  => Service['httpd']
  } ->
  exec { 'set_mysql_pass':
    command => 'config set mysql.pass blossom',
    path    => '/usr/share/phabricator/phabricator/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    cwd     => '/usr/share/phabricator/phabricator',
    notify  => Service['httpd']
  } ->
  exec { 'set_base_uri':
    command => "config set phabricator.base-uri 'http://192.168.2.27/'",
    path    => '/usr/share/phabricator/phabricator/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    cwd     => '/usr/share/phabricator/phabricator',
    notify  => Service['httpd']
  }
  
  exec { 'set_phd_user':
    command => "config set phd.user daemon-user",
    path    => '/usr/share/phabricator/phabricator/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    cwd     => '/usr/share/phabricator/phabricator',
    notify  => Service['httpd']
  }
  
  exec { 'set_vcs_user':
    command => "config set diffusion.ssh-user vcs-user",
    path    => '/usr/share/phabricator/phabricator/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    cwd     => '/usr/share/phabricator/phabricator',
    notify  => Service['httpd']
  }
  

  file { '/var/repo':
    owner   => "vcs-user",
    group   => "phabricator",
    mode    => 755,
    ensure  => "directory",
    recurse => true,
  }

  class { 'sudo':
  }

  sudo::conf { 'vcs-user':
    priority => 10,
    content  => "vcs-user ALL=(daemon-user) SETENV: NOPASSWD: /path/to/bin/git-upload-pack, /path/to/bin/git-receive-pack, /path/to/bin/hg, /path/to/bin/svnserve",
  }

  sudo::conf { 'web-user':
    priority => 9,
    content  => "www-user ALL=(daemon-user) SETENV: NOPASSWD: /usr/bin/git-http-backend, /usr/bin/hg",
  }

  # TODO: remomve Defaults    requiretty
  
  group { 'phabricator':
    ensure  => present,
    members => 'apache',
  } ->
  user { 'daemon-user':
    ensure => present,
    groups => 'phabricator',
    system => true,
    uid    => 10001,
  } ->
  user { 'vcs-user':
    ensure => present,
    groups => 'phabricator',
    system => true,
    uid    => 10002,
  }
  # http://www.phabricator.com/rsrc/install/install_rhel-derivs.sh
  # sudo yum install pcre-devel
  # https://secure.phabricator.com/book/phabricator/article/configuration_guide/
}