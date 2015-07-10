#
# Cookbook Name:: bcpc
# Recipe:: nova-setup
#
# Copyright 2013, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "bcpc::keystone"
include_recipe "bcpc::nova-head"

# spin until nova starts to respond, avoids blowing up on an HTTP 503
# if Apache was restarted recently and is not yet ready
bash "wait-for-nova-to-become-operational" do
  code ". /root/adminrc; until nova secgroup-list >/dev/null 2>&1; do sleep 1; done"
  timeout 30
end


bash "nova-configure-default-secgroup-rules" do
    user "root"
    code <<-EOH
        . /root/adminrc
        nova secgroup-add-default-rule icmp -1 -1 0.0.0.0/0
        nova secgroup-add-default-rule tcp 22 22 0.0.0.0/0
    EOH
    not_if ". /root/adminrc; nova secgroup-list-default-rules | grep icmp"
end

#bash "nova-floating-add" do
#    user "root"
#    code <<-EOH
#        . /root/adminrc
#        nova-manage floating create --ip_range=#{node['bcpc']['floating']['available_subnet']} --pool #{node['bcpc']['region_name']}
#    EOH
#    only_if ". /root/adminrc; nova-manage floating list | grep \"No floating IP addresses have been defined\""
#end

bash "nova-fixed-add" do
    user "root"
    code <<-EOH
        . /root/adminrc
        nova network-create fixed --fixed_range_v4 #{node['bcpc']['floating']['available_subnet']} --multi_host T --bridge br100
    EOH
    only_if ". /root/adminrc; nova net-list | grep \"No \""
end
