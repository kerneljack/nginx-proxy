#!/usr/bin/env bash

apt-get update && apt-get -yy dist-upgrade && apt-get -yy install vim puppet
echo "192.168.1.110  puppet" >> /etc/hosts
puppet agent --enable && puppet agent -t 

