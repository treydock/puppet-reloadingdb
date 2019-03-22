#!/bin/bash

ENV=${1:-deploy}

# Bootstrap Puppet
yum install -y https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
yum install -y puppet-agent

# Bootstrap r10k
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

# Bootstrap GPG and secrets
rm -rf /root/.gnupg
gpg --import /root/treydock.gpg
/opt/puppetlabs/puppet/bin/gem list | egrep -q "^hiera-eyaml-gpg"
if [ $? -ne 0 ]; then
    /opt/puppetlabs/puppet/bin/gem install hiera-eyaml-gpg --no-ri --no-rdoc
fi
/opt/puppetlabs/puppet/bin/gem list | egrep -q "^gpgme"
if [ $? -ne 0 ]; then
    /opt/puppetlabs/puppet/bin/gem install gpgme --no-ri --no-rdoc
fi
