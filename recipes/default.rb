#
# Cookbook Name:: lapack
# Recipe:: default
# Author:: Koji Tanaka (<kj.tanaka@gmail.com>)
#
# Copyright 2014, FutureGrid, Indiana University
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

include_recipe 'build-essential'

node['lapack']['required_packages'].each do |pkg|
  package pkg do
    action :install
  end
end

directory node['lapack']['download_dir'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "#{node['lapack']['download_dir']}/lapack-#{node['lapack']['version']}.tgz" do
  source node['lapack']['download_url']
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end

execute "extract_tarball" do
  cwd node['lapack']['download_dir']
  command "tar zxf lapack-#{node['lapack']['version']}.tgz"
  creates "lapack-#{node['lapack']['version']}"
end

cookbook_file "#{node['lapack']['download_dir']}/lapack-#{node['lapack']['version']}/make.inc" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "make" do
  cwd "#{node['lapack']['download_dir']}/lapack-#{node['lapack']['version']}/SRC"
  command "make"
  creates "../liblapack.a"
end

directory "#{node['lapack']['install_dir']}/lapack-#{node['lapack']['version']}/lib" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "copy_liblapack" do
  cwd "#{node['lapack']['download_dir']}/lapack-#{node['lapack']['version']}"
  command "cp liblapack.a #{node['lapack']['install_dir']}/lapack-#{node['lapack']['version']}/lib"
  creates "#{node['lapack']['install_dir']}/lapack-#{node['lapack']['version']}/lib/liblapack.a"
end

