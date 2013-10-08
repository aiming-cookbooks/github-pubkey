[![Build Status](https://travis-ci.org/aiming-cookbooks/github-pubkey.png?branch=master)](https://travis-ci.org/aiming-cookbooks/github-pubkey)

github-pubkey cookbook
=============

Fetch public keys into authorized_keys via github

Description
===========

This cookbook fetches public keys into authorized_keys via github API (like https://github.com/udzura.keys)

May this work on these platforms:

* Ubuntu
* Debian
* CentOS 6
* Amazon Linux

Please report me if not.

Requirements
============

none.

Attributes
==========

* `node['github-pubkey']['members'] = %w(udzura akubi)` - Sets operators' github account
* `node['github-pubkey']['username'] = 'ops'` - Sets OS username of the operator. `authorized_keys` will be installed to his `~/.ssh`
* `node['github-pubkey']['home_path'] = '/home/ops'` - Sets home directory where `authorized_keys` will be installed

`node['github-pubkey']['username']` or `node['github-pubkey']['home_path']` must be specified.

Recipes
=======

default
-------

Installs/updates `authorized_keys` via github API.

Resources/Providers
===================

`#=> nil`

License
=======

MIT License; See `LICENSE`



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/aiming-cookbooks/github-pubkey/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

