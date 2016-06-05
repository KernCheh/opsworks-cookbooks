include_recipe 'ruby_build'

# install ruby
ruby_build_ruby node[:opsworks][:ruby_version] do
  prefix_path '/usr/local/'
end

#install bundler
gem_package 'bundler' do
  options '--no-ri --no-rdoc'
end
