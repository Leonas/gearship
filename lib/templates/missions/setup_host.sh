#!/bin/bash



source actions/install_basics.sh
source actions/install_docker.sh
source actions/configure_firewall.sh

# https://github.com/v2tec/watchtower
# Use watchtower to keep docker files auto updated
