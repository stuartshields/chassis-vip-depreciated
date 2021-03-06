class vip (
	$php = $vip_config[php],
	$path	= "/vagrant/extensions/vip",
) {
	file { "${$path}/local-config.php":
		content => template('vip/local-config.php.erb'),
		owner   => 'www-data',
		group   => 'www-data',
		mode    => 0644,
	}

	file { "/vagrant/content/config":
		ensure => "directory",
		owner   => 'www-data',
		group   => 'www-data',
		mode    => 0644,
	}

	file { "/vagrant/content/config/roles.php":
		content => template('vip/roles.php.erb'),
		owner   => 'www-data',
		group   => 'www-data',
		mode    => 0644,
	}

	file { "/vagrant/content/config/vip-config.php":
		content => template('vip/vip-config.php.erb'),
		owner   => 'www-data',
		group   => 'www-data',
		mode    => 0644,
	}

	file { "/vagrant/content/config/batcache-config.php":
		content => template('vip/batcache-config.php.erb'),
		owner   => 'www-data',
		group   => 'www-data',
		mode    => 0644,
	}

	file { "/vagrant/content/advanced-cache.php":
		content => template('vip/advanced-cache.php.erb'),
		owner   => 'www-data',
		group   => 'www-data',
		mode    => 0644,
	}
}
