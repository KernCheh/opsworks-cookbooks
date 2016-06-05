if node[:opsworks][:instance][:layers].include?('rails-app') ||
  node[:opsworks][:instance][:layers].include?('rails-app2') ||
  node[:opsworks][:instance][:layers].include?('sidekiq') ||
  node[:opsworks][:instance][:layers].include?('recurring') ||
  (node[:opsworks][:instance][:layers] & (node[:set_env_for] || [])).size > 0

  include_recipe "opsworks_custom_env::restart_command"
  include_recipe "opsworks_custom_env::write_config"

end
