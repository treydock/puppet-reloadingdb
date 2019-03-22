# puppet-reloadingdb

This is the main control repo for r10k to deploy [reloadingdb](https://github.com/treydock/puppet-reloadingdb)

# Bootstrap

```
yum install -y curl
curl -o /root/bootstrap.sh https://raw.githubusercontent.com/treydock/puppet-reloadingdb/production/scripts/bootstrap.sh
bash /root/bootstrap.sh
/opt/puppetlabs/puppet/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

# eyaml commands

Edit:

```
eyaml edit -n gpg --gpg-always-trust --gpg-recipients-file=./hiera-eyaml-gpg.recipients data/common.eyaml
```
