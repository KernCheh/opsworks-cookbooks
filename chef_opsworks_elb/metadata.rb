name 'chef_opsworks_elb'
maintainer 'CrowdMob Inc.'
maintainer_email 'developers@crowdmob.com'
license 'Apache 2.0'
description 'Provides recipes to register and deregister from elb for an opsworks instance'
version '0.0.2'

recipe 'chef_opsworks_elb::register', 'Registers instances with ELB'
recipe 'chef_opsworks_elb::deregister', 'De-registers instances with ELB'