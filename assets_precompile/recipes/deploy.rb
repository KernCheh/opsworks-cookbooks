node[:deploy].each do |application, deploy|

  # Precompile assets. Assets are compiled into shared/assets and shared between deploys.
  shared_path = "#{deploy[:deploy_to]}/shared"
  release_path = "#{deploy[:deploy_to]}/current"

  # create shared directory for assets, if it doesn't exist
  directory "#{shared_path}/assets" do
    mode 0770
    action :create
    recursive true
  end

  # symlink current deploy's asset folder to shared assets each deploy
  link "#{release_path}/public/assets" do
    to "#{shared_path}/assets"
  end

  # precompile assets into public/assets (which is symlinked to shared assets folder)
  rails_env = node[:deploy][application][:rails_env]

  execute "rake assets:clean" do
    cwd release_path
    command "sudo su deploy -c 'RAILS_ENV=#{rails_env} bundle exec rake assets:clean'"
    environment 'RAILS_ENV' => rails_env
  end

  execute "rake tmp:clear" do
    cwd release_path
    command "RAILS_ENV=#{rails_env} bundle exec rake tmp:clear"
    environment 'RAILS_ENV' => rails_env
  end

  execute "rake assets:precompile" do
    cwd release_path
    command "rm -rf tmp/cache && sudo su deploy -c 'RAILS_ENV=#{rails_env} bundle exec rake assets:precompile'"
    environment 'RAILS_ENV' => rails_env
  end

  execute "rake webpack:compile" do
    cwd release_path
    command "sudo su deploy -c 'yarn install && npm rebuild node-sass && RAILS_ENV=#{rails_env} bundle exec rake webpack:compile'"
    environment 'RAILS_ENV' => rails_env

    only_if do
      !!deploy[:webpack_compile]
    end
  end

  Chef::Log.info("Restart command #{node[:opsworks][:rails_stack][:restart_command]}")
  execute "restart Rails application #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]

    only_if do
      !deploy[:restart_on_cookbook] || deploy[:restart_on_cookbook] == cookbook_name.to_s
    end
  end
end
