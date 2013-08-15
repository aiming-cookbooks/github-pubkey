#
# Cookbook Name:: github-pubkey
# Recipe:: default
#
# Copyright 2013, Aiming Inc / Uchio KONDO
#
# MIT License
#

node["github-pubkey"]["github-members"].each do |name|
  remote_file "#{Chef::Config[:file_cache_path]}/#{name}.authorized_keys" do
    source "https://github.com/#{name}.keys"
    action :create
  end
end

bash "concat authorized_keys" do
  cwd Chef::Config[:file_cache_path]
  code %{ cat *.authorized_keys > authorized_keys }
end

# all .ssh directory existance
node["github-pubkey"]["usernames"].each do |username|
  directory "/home/#{username}/.ssh" do
    owner  username
    group  username
    mode   0700
  end
end

all_key_file = "#{Chef::Config[:file_cache_path]}/authorized_keys"

node["github-pubkey"]["usernames"].each do |username|
  authorized_keys = "/home/#{username}/.ssh/authorized_keys"

  bash "copy authorized_keys" do
    cwd Chef::Config[:file_cache_path]
    code   %{ cp   "#{all_key_file}" "#{authorized_keys}" }
    not_if %{ diff "#{all_key_file}" "#{authorized_keys}" }
  end

  file authorized_keys do
    owner username
    group username
    mode 0600
  end
end
