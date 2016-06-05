default['le']['logs_to_follow'] = [
    {name: 'syslog', log: '/var/log/syslog'},
    {name: 'varlog', log: '/var/log/*.log'}
]

if node[:opsworks][:instance][:layers].include?('rails-app')
  default['le']['logs_to_follow'] << {name: 'rails-server', log: '/srv/www/luxola_wms/shared/log/production.log'}
end

if node[:opsworks][:instance][:layers].include?('rails-app2')
  default['le']['logs_to_follow'] << {name: 'rails-server-reports', log: '/srv/www/luxola_wms/shared/log/production.log'}
end

if node[:opsworks][:instance][:layers].include?('sidekiq')
  default['le']['logs_to_follow'] << {name: 'sidekiq-log', log: '/srv/www/luxola_wms/shared/log/sidekiq.log'}
  default['le']['logs_to_follow'] << {name: 'sidekiq-dblog', log: '/srv/www/luxola_wms/shared/log/production.log'}
end

if node[:opsworks][:instance][:layers].include?('mq')
  default['le']['logs_to_follow'] << {name: 'message-queue-log', log: '/srv/www/luxola_wms/shared/log/sneakers.log'}
  default['le']['logs_to_follow'] << {name: 'message-queue-dblog', log: '/srv/www/luxola_wms/shared/log/production.log'}
end
