#!/bin/bash

ENV=${1:-deploy}

yum install -y git
/opt/puppetlabs/puppet/bin/gem install r10k --no-ri --no-rdoc
if [ "$ENV" = "test" ]; then
    if [ -d /etc/puppetlabs/code/environments/production ]; then
        rm -rf /etc/puppetlabs/code/environments/production
    fi
    ln -snf /vagrant /etc/puppetlabs/code/environments/production
else
    mkdir -p /etc/puppetlabs/r10k
    cat > /etc/puppetlabs/r10k/r10k.yaml <<EOF
---
:cachedir: /var/cache/r10k
:sources:
  puppet:
    basedir: /etc/puppetlabs/code/environments
    ignore_branch_prefixes: ["ignore", "omit"]
    remote: https://github.com/treydock/puppet-reloadingdb.git
    type: git
EOF
/opt/puppetlabs/puppet/bin/r10k deploy --verbose=info environment -p
fi