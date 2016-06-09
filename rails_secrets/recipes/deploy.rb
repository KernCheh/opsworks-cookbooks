node[:deploy].each do |application, deploy|

  shared_path = "#{deploy[:deploy_to]}/shared"
  release_path = "#{deploy[:deploy_to]}/current"

  if deploy[:rails_secrets]
    Chef::Log.debug('Cloning rails_secrets repo')

    git "#{shared_path}/luxola_secrets" do
      enable_submodules true
      depth nil
      user deploy[:user]
      group deploy[:group]
      action :checkout
      repository deploy[:rails_secrets][:scm][:repository]
      revision 'master'
      retries 2
    end
  end

  link "#{release_path}/config/secrets.yml" do
    to "#{shared_path}/luxola_secrets/secrets.yml"
  end
end
