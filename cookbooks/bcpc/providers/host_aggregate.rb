#
# Cookbook Name:: bcpc
# Provider:: host_aggregate
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
require 'open3'
require 'json'

def whyrun_supported?
  true
end

def openstack_cli
  # even on Kilo with a v1.1 compute API endpoint, force v2
  args =  ["openstack",
           "--os-tenant-name", node['bcpc']['admin_tenant'],
           "--os-project-name", node['bcpc']['admin_tenant'],
           "--os-username", get_config('keystone-admin-user'),
           "--os-compute-api-version", "2",
           "--os-auth-url", "#{node['bcpc']['protocol']['keystone']}://openstack.#{node['bcpc']['cluster_domain']}:#{node['bcpc']['catalog']['identity']['ports']['public']}/#{node['bcpc']['catalog']['identity']['uris']['public']}/",
           "--os-region-name", node['bcpc']['region_name'],
           "--os-password" , get_config('keystone-admin-password')]

  if get_api_version(:identity) == "3"
    args += ["--os-project-domain-name", "default", "--os-user-domain-name", "default"]
  end

  return args
end

action :create do
  stdout, stderr, status = Open3.capture3(*(openstack_cli +
  	                                    ["aggregate", "show",
                                             @new_resource.name, "-f", "json" ]))

  if not status.success?
    converge_by("Creating host aggregate #{new_resource.name}") do
      args = ["aggregate", "create", @new_resource.name , "-f", "json"]
      args += ["--zone", "#{@new_resource.zone}"] unless @new_resource.zone.nil?
      stdout, status = Open3.capture2( *(openstack_cli + args +
     		                         @new_resource.metadata.collect {|k , v| ["--property", k.to_s + "=" + v.to_s ] }.flatten ))
      Chef::Log.error "Failed to create host aggregate" unless status.success?
    end
  else
    ha_fields = JSON.parse(stdout)
    current_properties = ha_fields.select {|x| x['Field'] == "properties"}[0]["Value"]

    # update metadata if needed
    new_properties = current_properties.clone
    @new_resource.metadata.each { |k,v| new_properties[k.to_s] = v.to_s }
    if new_properties != current_properties
      converge_by ("Update properties") do
	args = ["aggregate", "set", @new_resource.name]
	args += ["--zone", "#{@new_resource.zone}"] unless @new_resource.zone.nil?
	stdout, status = Open3.capture2( *(openstack_cli +
    	 		 	           args + new_properties.collect {|k , v| ["--property", k + "=" + v ] }.flatten ))
	Chef::Log.error "Failed to update host aggregate" unless status.success?
      end
    end
  end
end

action :member do
  # Adds the current host to the host aggregate
  stdout, stderr, status = Open3.capture3(*(openstack_cli +
  	                                    ["aggregate", "show", @new_resource.name, "-f", "json" ]))
  raise "Unable to find host aggregate #{@new_resource.name}" unless status.success?

  ha_fields = JSON.parse(stdout)
  current_hosts = ha_fields.select {|x| x['Field'] == "hosts"}[0]["Value"]
  if not current_hosts.include?(node['hostname'])
    converge_by ("Adding host") do
      stdout, stderr, status = Open3.capture3(*(openstack_cli +
  			                        ["aggregate", "add", "host", @new_resource.name, node['hostname'] ]))
    end
  end
end

action :depart do
  # Removes the current host from the host aggregate
  stdout, stderr, status = Open3.capture3(*(openstack_cli +
  	                                    ["aggregate", "show", @new_resource.name, "-f", "json" ]))
  raise "Unable to find host aggregate #{@new_resource.name}" unless status.success?

  ha_fields = JSON.parse(stdout)
  current_hosts = ha_fields.select {|x| x['Field'] == "hosts"}[0]["Value"]
  if current_hosts.include?(node['hostname'])
    converge_by ("Removing host") do
      stdout, stderr, status = Open3.capture3(*(openstack_cli +
  			                        ["aggregate", "remove", "host", @new_resource.name, node['hostname'] ]))
    end
  end
end
