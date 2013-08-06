#
# Cookbook Name:: github-pubkey
# Recipe:: default
#
# Copyright 2013, Aiming Inc / Uchio KONDO
#
# MIT License
#

authorized_keys = case
                  when username = node["github-pubkey"]["username"]
                    "/home/#{username}/.ssh/authorized_keys"
                  when home = node["github-pubkey"]["home_path"]
                    node["github-pubkey"]["username"] ||= home.split('/').last
                    "#{home}/.ssh/authorized_keys"
                  else
                    raise %q(Please specify ["github-pubkey"]["username"] or ["github-pubkey"]["home_path"])
                  end

node["github-pubkey"]["members"].each do |name|
  remote_file "#{Chef::Config[:file_cache_path]}/authorized_keys.#{name}" do
    source "https://github.com/#{name}.keys"
    action :create
  end
end

file authorized_keys do
  content Dir.glob("#{Chef::Config[:file_cache_path]}/authorized_keys.*")
             .map{|filename| File.read(filename) rescue "" }
             .join("\n")
  owner node["github-pubkey"]["username"]
  group node["github-pubkey"]["username"]
  mode 0400
  action :create
end
