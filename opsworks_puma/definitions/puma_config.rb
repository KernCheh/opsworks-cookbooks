define :puma_config, :owner => 'deploy', :group => 'www-data', :directory  => nil, :puma_directory => nil, :working_dir => nil, :rackup => nil,
       :environment => 'production', :daemonize => true, :pidfile => nil, :config_path => nil, :state_path => nil,
       :stdout_redirect => nil, :stderr_redirect => nil, :output_append => true,
       :quiet => false, :thread_min => 0, :thread_max => 16, :bind => nil, :control_app_bind => nil,
       :workers => 0, :activate_control_app => true, :logrotate => true, :exec_prefix => nil,
       :config_source => nil, :config_cookbook => nil, :worker_timeout => nil,
       :preload_app => true, :prune_bundler => true, :on_worker_boot => nil do

  deploy = params[:deploy_data]

  params[:owner] = deploy[:user]
  params[:group] = deploy[:group]
  params[:directory] ||= "/srv/www/#{params[:name]}"
  params[:working_dir] ||= "#{params[:directory]}/current"
  params[:puma_directory] ||= "#{params[:directory]}/shared/puma"
  params[:config_path] ||= "#{params[:puma_directory]}/#{params[:name]}.config"
  params[:state_path] ||= "#{params[:puma_directory]}/#{params[:name]}.state"
  params[:bind] ||= "unix://#{params[:puma_directory]}/#{params[:name]}.sock"
  params[:control_app_bind] ||= "unix://#{params[:puma_directory]}/#{params[:name]}_control.sock"
  params[:pidfile] ||= "#{params[:directory]}/shared/pids/#{params[:name]}.pid"
  params[:stdout_redirect] ||= "#{params[:working_dir]}/log/puma.log"
  params[:stderr_redirect] ||= "#{params[:working_dir]}/log/puma.error.log"
  params[:bin_path] ||= 'puma'
  params[:exec_prefix] ||= 'bundle exec'
  params[:config_source] ||= 'puma.rb.erb'
  params[:config_cookbook] ||= 'opsworks_puma'
  params[:worker_timeout] ||= '60'

  group params[:group]

  Chef::Log.info "Creating user with #{params[:owner]} with group #{params[:group]}"

  user params[:owner] do
    action :create
    comment 'deploy user'
    uid next_free_uid
    gid params[:group]
    home deploy[:home]
    supports :manage_home => true
    shell deploy[:shell]
    not_if do
      existing_usernames = []
      Etc.passwd {|user| existing_usernames << user['name']}
      existing_usernames.include?(params[:owner])
    end
  end

  # Create app working directory with owner/group if specified
  directory params[:puma_directory] do
    recursive true
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
  end

  template params[:name] do
    source params[:config_source]
    path params[:config_path]
    cookbook params[:config_cookbook]
    mode '0644'
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    variables params
  end

  template 'puma_start.sh' do
    source 'puma_start.sh.erb'
    path "#{params[:puma_directory]}/puma_start.sh"
    cookbook 'opsworks_puma'
    mode '0744'
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    variables params
  end

  template 'puma_stop.sh' do
    source 'puma_stop.sh.erb'
    path "#{params[:puma_directory]}/puma_stop.sh"
    cookbook 'opsworks_puma'
    mode '0744'
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    variables params
  end

  template 'puma_restart.sh' do
    source 'puma_restart.sh.erb'
    path "#{params[:puma_directory]}/puma_restart.sh"
    cookbook 'opsworks_puma'
    mode '0744'
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    variables params
  end

  service params[:name] do
    supports :start => true, :stop => true, :restart => true
    action :nothing
  end

  template "#{params[:name]}" do
    source 'init.d.sh.erb'
    path "/etc/init.d/#{params[:name]}"
    cookbook 'opsworks_puma'
    mode '0755'
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    variables params
    notifies :start, "service[#{params[:name]}]", :delayed
  end

  if params[:logrotate]
    logrotate_app params[:name] do
      cookbook 'logrotate'
      path [ params[:stdout_redirect], params[:stderr_redirect] ]
      frequency 'daily'
      rotate 30
      size '5M'
      options ['missingok', 'compress', 'delaycompress', 'notifempty', 'dateext']
    end
  end
end
