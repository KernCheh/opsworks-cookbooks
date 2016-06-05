include_recipe 'ruby_build'

ruby_build_ruby node[:opsworks][:ruby_version]

magic_shell_environment 'PATH' do
  value "$PATH:/usr/local/ruby/#{node[:opsworks][:ruby_version]}/bin"
end
