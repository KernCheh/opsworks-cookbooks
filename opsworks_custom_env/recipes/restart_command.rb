node[:deploy].each do |application, deploy|

  execute "restart Rails app #{application} for custom env" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    user deploy[:user]

    action :nothing

    only_if do
      !deploy[:restart_on_cookbook] || deploy[:restart_on_cookbook] == cookbook_name.to_s
    end
  end
end
