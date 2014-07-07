#
# Puppet master cluster
#
domain   = 'coetzee.com'
box      =  'centos65-x86_64_3'
url      = 'file:///home/coetzeer/cloud/dropbox/Dropbox/centos65-x86_64_3.box'


nodes = [
  { :hostname => 'rcs-common',     		:ip => '192.168.2.25', :box => box, :ram => 512, :ssh_port => 2225 },
  { :hostname => 'gitolite',     		:ip => '192.168.2.28', :box => box, :ram => 512, :ssh_port => 2228 },
  { :hostname => 'gitlab',    			:ip => '192.168.2.22', :box => box, :ram => 512, :ssh_port => 2222 },
  { :hostname => 'gitorious',    		:ip => '192.168.2.23', :box => box, :ram => 512, :ssh_port => 2223 },
  { :hostname => 'reviewboard',    		:ip => '192.168.2.24', :box => box, :ram => 512, :ssh_port => 2224 },
  { :hostname => 'cvs',     			:ip => '192.168.2.21', :box => box, :ram => 512, :ssh_port => 2221 },
  { :hostname => 'svn',                 	:ip => '192.168.2.26', :box => box, :ram => 512, :ssh_port => 2226 },
  { :hostname => 'hg', 			        :ip => '192.168.2.27', :box => box, :ram => 512, :ssh_port => 2227 },
  { :hostname => 'gerrit',		        :ip => '192.168.2.29', :box => box, :ram => 512, :ssh_port => 2229 },
]

Vagrant.configure("2") do |config|

  nodes.each do |node|  
    config.vm.define node[:hostname] do |node_config|
	      node_config.vm.box = node[:box]
	      node_config.vm.box_url = url	
	      node_config.vm.host_name = node[:hostname] + '.' + domain
	      node_config.vm.hostname = node[:hostname] + '.' + domain
	      config.vm.network "private_network", ip: node[:ip]
		  #config.vm.network :forwarded_port, guest: 22, host: node[:ssh_port]
		  #config.ssh.guest_port = node[:ssh_port]
		  
	      memory = node[:ram] ? node[:ram] : 256;
	     
	     config.vm "virtualbox" do |v|
		      v.customize[
		          'modifyvm', :id,
		          '--name', node[:hostname],
		          '--memory', memory.to_s
		        ]		        
	     end

		 config.vm.provision "shell", path: "provision.sh"
		
		 #config.vm.provision "puppet_server" do |puppet|
		 #   puppet.puppet_server = "puppet.coetzee.com"
		 #   puppet.options = "--waitforcert=60 --debug"
		 #end
		 
		 config.vm.provision :puppet do |puppet|
	      	puppet.manifests_path = 'manifests'
	    	puppet.manifest_file = 'site.pp'
	    	puppet.module_path = 'modules'
	    	#puppet.hiera_config_path = "hiera.yaml"
	    	puppet.working_directory = "/vagrant"
	    	puppet.options = " --debug"
	    	#--verbose --storeconfigs --dbadapter=mysql --dbuser=puppet --dbpassword=password --dbserver=localhost
	    end

     
    end #end node_config
    
  end # end node loop
  
end #end config
