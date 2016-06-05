# Default
default['le']['account_key'] = ''
default['le']['hostname'] = node['hostname']

# default['le']['logs_to_follow'] = [{:name => 'syslog', :log => '/var/log/syslog'},{:name => 'varlog', :log => '/var/log/*.log'}]
default['le']['logs_to_follow'] = [
    {:name => 'syslog', :log => '/var/log/syslog'},
    {:name => 'varlog', :log => '/var/log/*.log'},
    {:name => 'unicorn_stdout', :log => '/srv/www/luxola_wms/shared/log/unicorn.stdout.log'},
    {:name => 'unicorn_stderr', :log => '/srv/www/luxola_wms/shared/log/unicorn.stderr.log'},
    {:name => '', :log => '/var/log/nginx/error.log'}
]


# Datahub
default['le']['datahub']['enable'] = false
default['le']['datahub']['server_ip'] = '127.0.0.1'
default['le']['datahub']['port'] = 10000

# Pull server side config
default['le']['pull-server-side-config'] = true

# PGP Key Server
default['le']['pgp_key_server'] = 'pgp.mit.edu'

# Debian Release

default['le']['deb'] = node['lsb']['codename']
