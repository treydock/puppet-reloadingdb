#!/bin/bash

rm -rf /root/.gnupg
gpg --import /root/treydock.gpg
/opt/puppetlabs/puppet/bin/gem install hiera-eyaml-gpg --no-ri --no-rdoc
/opt/puppetlabs/puppet/bin/gem install gpgme --no-ri --no-rdoc
