#
# Cookbook Name:: nodejs
# Attributes:: nodejs
#
# Copyright 2010-2012, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'smartos', 'rhel', 'fedora', 'debian', 'mac_os_x'
  default['nodejs']['install_method'] = 'package'
else
  default['nodejs']['install_method'] = 'source'
end

default['nodejs']['engine'] = 'node' # or iojs

default['nodejs']['version'] = '7.9.0'

default['nodejs']['prefix_url']['node'] = 'https://nodejs.org/dist/'
default['nodejs']['prefix_url']['iojs'] = 'https://iojs.org/dist/'

default['nodejs']['source']['url']      = nil # Auto generated
default['nodejs']['source']['checksum'] = 'a569764b884929f31a0772600a5cf36048ad42aa8c54ba4cabea6c067ef96a29'

default['nodejs']['binary']['url'] = nil # Auto generated
default['nodejs']['binary']['checksum']['linux_x64'] = 'd8910cf0dd90be84c07df179512cf2e36659a92726e67e8dc8bc8b457fe6e5ee'
default['nodejs']['binary']['checksum']['linux_x86'] = 'a1178015504b81d1a42d72feebf80e3e7c96f3ff64ef17157e22f886c7d29e64'
default['nodejs']['binary']['checksum']['linux_arm64'] = '2dff3ee0c0a5e9b3adc6b8af8fb5a9f1fb47917a7e8538497a7125f50fc685d3'

default['nodejs']['make_threads'] = node['cpu'] ? node['cpu']['total'].to_i : 2

default['nodejs']['manage_node'] = true
