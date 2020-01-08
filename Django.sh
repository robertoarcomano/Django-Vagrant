#!/bin/bash
# 0. Destroy existence vagrant VMs
vagrant destroy -f

# 1. Start Vagrant VMs
vagrant up --provider=libvirt

# 2. Launch tests
vagrant ssh -c "sudo /vagrant/testDjango.sh"
