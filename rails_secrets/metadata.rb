name              'rails_secrets'
description       'Installs and configures Rails secrets.yml from private repo'
recipe            'rails_secrets::default',   'Downloads and setup secrets.yml'

depends 'deploy'

recipe 'rails_secrets::deploy', 'Symlink secrets.yml into current app folder'
