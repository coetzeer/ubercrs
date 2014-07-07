#!/bin/bash -e

#rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
            
function install_module {
   if [ ! -d /etc/puppet/modules/$1 ];
    then
        puppet module install $2 --modulepath /etc/puppet/modules
    fi
}

function add_host {
	echo "checking hosts file for $1"
	EXISTS=`grep $2 /etc/hosts | wc -l`
	if [ $EXISTS -eq 0 ];then
		echo "$2    $1.coetzee.com    $1" >> /etc/hosts
	else
		echo "host $1 exists"
	fi
}

function init_modules {
	rm -fr /etc/puppet/modules
	git clone /vagrant/shared_modules/.git /etc/puppet/modules
	#git clone coetzeer@192.168.2.1:~/git/shared_modules/.git
}

function commit_back_to_repo {
	cd /etc/puppet/modules
	GIT_STATUS=`git status | grep "nothing to commit" | wc -l`
	if [ $GIT_STATUS -eq 0 ];
	then
		git add *
		git commit -m "updating modules"
		git push
	fi
}

init_modules
install_module mysql puppetlabs-mysql
install_module apache puppetlabs-apache
install_module puppetdb puppetlabs-puppetdb
install_module dashboard puppetlabs-dashboard
install_module gerrit roidelapluie-gerrit
install_module reviewboard saw-reviewboard
install_module gitlab sbadia-gitlab
install_module wls biemond-wls
install_module oradb biemond-oradb
install_module phppgadmin knowshan-phppgadmin
install_module timezone bashtoni-timezone
install_module ntp puppetlabs-ntp
install_module mercurial jgoettsch-mercurial
install_module sudo saz-sudo
commit_back_to_repo

add_host gitolite 192.168.2.28
add_host gitlab 192.168.2.22
add_host gitorious 192.168.2.23
add_host reviewboard 192.168.2.24
add_host cvs 192.168.2.21       
add_host svn 192.168.2.26
add_host hg 192.168.2.27
add_host gerrit 192.168.2.29


add_host puppet 192.168.2.31
add_host master1 192.168.2.32
add_host master2 192.168.2.33
add_host cacert1 192.168.2.34
add_host cacert2 192.168.2.35       
add_host puppetdb-postgres 192.168.2.36
add_host puppetdb 192.168.2.37
add_host dashboard 192.168.2.38
      
