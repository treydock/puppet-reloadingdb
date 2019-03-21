#!/bin/bash

ENV=${1:-deploy}

yum install -y git
/opt/puppetlabs/puppet/bin/gem install r10k
mkdir -p /etc/puppetlabs/r10k
if [ "$ENV" = "test" ]; then
    GIT_REMOTE="/vagrant"
else
    GIT_REMOTE="https://github.com/treydock/puppet-reloadingdb.git"
fi
cat > /etc/puppetlabs/r10k/r10k.yaml <<EOF
---
:cachedir: /var/cache/r10k
:sources:
  puppet:
    basedir: /etc/puppetlabs/code/environments
    ignore_branch_prefixes: ["ignore", "omit"]
    remote: ${GIT_REMOTE}
    type: git
EOF
/opt/puppetlabs/puppet/bin/r10k deploy --verbose=info environment -p
