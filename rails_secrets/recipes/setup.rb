node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping rails_secrets::default application #{application} as it is not an Rails app")
    next
  end

  opsworks_deploy_user do
    deploy_data deploy
  end

  Chef::Log.debug('Creating SSH directory if it does not exist')
  directory '/home/deploy/.ssh' do
    mode 0755
    owner 'deploy'
    group 'www-data'
    action :create
  end

  Chef::Log.debug('Creating rails_secrets private key')
  execute 'create_rails_secrets' do
    cwd '/home/deploy/.ssh'
    command "echo '#{deploy[:rails_secrets][:scm][:ssh_key]}' > rails_secrets"
  end

  Chef::Log.debug('Updating SSH config')
  template '/home/deploy/.ssh/config' do
    source 'config.erb'
    owner deploy[:user]
    group deploy[:group]
    mode '400'
  end
end
