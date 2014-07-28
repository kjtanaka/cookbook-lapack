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

directory "/root/source" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "/root/source/lapack-3.5.0.tgz" do
  source "http://www.netlib.org/lapack/lapack-3.5.0.tgz"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end

execute "extract_tarball" do
  cwd "/root/source"
  command "tar zxf lapack-3.5.0.tgz"
  creates "lapack-3.5.0"
end

cookbook_file "/root/source/lapack-3.5.0/make.inc" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "make" do
  cwd "/root/source/lapack-3.5.0/SRC"
  command "make"
  creates "../liblapack.a"
end

directory "/opt/lapack-3.5.0/lib" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "copy_liblapack" do
  cwd "/root/source/lapack-3.5.0"
  command "cp liblapack.a /root/source/lapack-3.5.0"
  creates "/root/source/lapack-3.5.0/liblapack.a"
end
