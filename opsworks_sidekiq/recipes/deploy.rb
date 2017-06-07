# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb

include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks_sidekiq::deploy application #{application} as it is not a Rails app")
    next
  end

  if deploy[:sidekiq_in_same_instance]

    Chef::Log.debug("Running opsworks_sidekiq::setup quick restart for application #{application}")
    node.set[:opsworks][:rails_stack][:recipe] = "opsworks_sidekiq::setup"

  else

    opsworks_deploy_dir do
      user deploy[:user]
      group deploy[:group]
      path deploy[:deploy_to]
    end

    Chef::Log.debug("Running opsworks_sidekiq::setup for application #{application}")
    node.set[:opsworks][:rails_stack][:recipe] = "opsworks_sidekiq::setup"
    node.set[:opsworks][:rails_stack][:restart_command] = node[:sidekiq][application][:restart_command]

    opsworks_rails do
      deploy_data deploy
      app application
    end

    Chef::Log.debug("Deploying Sidekiq Application: #{application}")

    opsworks_deploy do
      deploy_data deploy
      app application
    end
  end

  Chef::Log.debug("Restarting Sidekiq Application: #{application}")
  execute "restart Rails app #{application}" do
    command "sleep 60 && #{node[:sidekiq][application][:restart_command]}"

    only_if do
      !deploy[:restart_on_cookbook] || deploy[:sidekiq_in_same_instance] || deploy[:restart_on_cookbook] == cookbook_name.to_s
    end
  end
end
