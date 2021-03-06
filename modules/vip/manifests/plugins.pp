class vip::plugins (
	$path	= "/vagrant/extensions/vip",
	$vip_config = sz_load_config(),

	$plugins = [
		'monster-widget',
		'user-switching',
		'wordpress-importer',
		'query-monitor',

		# WordPress.com
		'keyring',
		'mrss',
		'polldaddy',
		'jetpack',
	],

	$github_plugins = [
		'amp-wp',
		'media-explorer',
		# 'vip-scanner', // We need to find a way to do submodule init - vendor/PHP-Parser
		'writing-helper',
	],
) {
	if ! ( File['/vagrant/content'] ) {
		file { "/vagrant/content":
			ensure => "directory",
		}
	}

	if ! ( File['/vagrant/content/plugins'] ) {
		file { "/vagrant/content/plugins":
			ensure => "directory",
		}
	}

	vip::gitcheck { $github_plugins: }

	# Install plugins
	wp::plugin { $plugins:
		location => '/vagrant/wp',
		require  => Class['wp']
	}

	# Update all the plugins
	wp::command { 'plugin update --all':
		command  => 'plugin update --all',
		location => '/vagrant/wp',
		require  => Wp::Site['/vagrant/wp'],
	}

	if ! ( File['/vagrant/content/themes/vip'] ) {
		file { "/vagrant/content/themes/vip":
			ensure => "directory",
		}
	}

	exec { "vip-install":
		command => "git clone https://github.com/svn2github/wordpress-vip-plugins.git /vagrant/content/themes/vip/plugins",
   		path	=> '/usr/bin/',
		require => Package[ 'git-core' ],
		onlyif  => "test ! -d /vagrant/content/themes/vip/plugins",
		timeout => 0
	}

	exec { "vip-update":
		command => "git --work-tree=/vagrant/content/themes/vip/plugins --git-dir=/vagrant/content/themes/vip/plugins/.git pull origin master",
		path	=> [ '/usr/bin/', '/bin' ],
		require => [ Package[ 'git-core' ] ],
		onlyif  => "test -d /vagrant/content/themes/vip/plugins",
		timeout => 0
	}

	exec { "mu-plugins-install":
		command => "git clone https://github.com/stuartshields/chassis-vip-mu-plugins.git /vagrant/content/mu-plugins",
   		path	=> '/usr/bin/',
		require => Package[ 'git-core' ],
		onlyif  => "test ! -d /vagrant/content/mu-plugins",
		timeout => 0
	}

	exec { "mu-plugins-update":
		command => "git --work-tree=/vagrant/content/mu-plugins --git-dir=/vagrant/content/mu-plugins/.git pull origin master",
		path	=> [ '/usr/bin/', '/bin' ],
		require => [ Package[ 'git-core' ] ],
		onlyif  => "test -d /vagrant/content/mu-plugins",
		timeout => 0
	}
}
