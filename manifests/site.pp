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
  class { 'phabricator': mysql_rootpass => 'blossom', }

  class { 'mercurial': }

  ini_setting { 'mercurial_ini':
    ensure  => present,
    path    => '/etc/mercurial/hgrc',
    section => 'trusted',
    setting => 'groups',
    value   => 'phabricator',
    require => Class['mercurial']
  }

  ini_setting { 'mercurial_ini':
    ensure  => present,
    path    => '/etc/mercurial/hgrc',
    section => 'trusted',
    setting => 'users',
    value   => 'apache,vcs-user,phd-user',
    require => Class['mercurial']
  }

}