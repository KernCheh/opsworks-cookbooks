node[:deploy].each do |application, deploy|

  node.set[:opsworks][:rails_stack][:restart_command] = ''

  if node[:cron_jobs][application]
    node[:cron_jobs][application].each do |job|
      cron job[:name] do
        job.each do |job_name, job_args|
          next if job_name == :name
          self.send(job_name, job_args)
        end
      end
    end
  end
end
