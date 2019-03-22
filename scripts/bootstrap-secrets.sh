#!/bin/bash

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
