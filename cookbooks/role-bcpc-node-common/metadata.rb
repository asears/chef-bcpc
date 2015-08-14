name             'role-bcpc-node-common'
maintainer       'Bloomberg Finance L.P.'
maintainer_email 'bcpc@bloomberg.net'
license          'Apache 2.0'
description      'Installs/Configures role-bcpc-node-common'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '6.0.0'

depends          'bcpc-health-check', '>= 6.0.0'
depends          'bcpc-crond',        '>= 6.0.0'
depends          'bcpc-sshd',         '>= 6.0.0'
depends          'bcpc-networking',   '>= 6.0.0'
depends          'bcpc-zabbix',       '>= 6.0.0'
depends          'bcpc-ceph',         '>= 6.0.0'
