#
# Cookbook Name:: github-pubkey
# Recipe:: default
#
# Copyright 2013, Aiming Inc / Uchio KONDO
#
# MIT License
#

file_path = "#{Chef::Config[:file_cache_path]}/authorized_keys"

b = bash "concat authorized_keys" do
  cwd Chef::Config[:file_cache_path]

  code <<-EOC
    cat *.authorized_keys > authorized_keys
  EOC

  action :nothing

  not_if { File.exists? file_path }
end

# copy authorized_keys to users
node["github-pubkey"]["usernames"].each do |username|

  d = directory "/home/#{username}/.ssh" do
    owner  username
    group  username
    mode   0700
    action :nothing
  
    not_if { File.exists? "/home/#{username}/.ssh" }
  end
  
  f = file "/home/#{username}/.ssh/authorized_keys" do
    content IO.read("#{Chef::Config[:file_cache_path]}/authorized_keys") if File.exists?(file_path)
    owner   username
    group   username
    mode    0600
    action  :nothing 
  end

  node["github-pubkey"]["github-members"].each do |name|
    
    r = remote_file "#{Chef::Config[:file_cache_path]}/#{name}.authorized_keys" do
      source "https://github.com/#{name}.keys"
      action :nothing
    end
    r.run_action(:create)
   
  end

  b.run_action(:run)
  d.run_action(:create)
  f.run_action(:create)

end
