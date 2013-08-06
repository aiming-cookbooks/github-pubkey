#
# Cookbook Name:: github-pubkey
# Recipe:: default
#
# Copyright 2013, Aiming Inc / Uchio KONDO
#
# MIT desu
#

authorized_keys = case
                  when username = node["github-pubkey"]["username"]
                    "/home/#{username}/.ssh/authorized_keys"
                  when home = node["github-pubkey"]["home_path"]
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

execute "concat authorized_keys" do
  command <<EOC
bash -l -c '\
  cat #{Chef::Config[:file_cache_path]}/authorized_keys.* > #{authorized_keys}
'
EOC
end
