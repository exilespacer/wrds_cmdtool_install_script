#!/bin/bash
# reference: https://docs.docker.com/engine/installation/binaries/
set -e
mkdir -p $HOME/local $HOME/docker_tmp
cd $HOME/docker_tmp

wget -O docker-latest.tgz https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
tar -xvzf docker-latest.tgz
mv docker/* $HOME/local/bin/
rm -rf $HOME/docker_tmp

echo "$HOME/local/bin/docker is now available. Please refer to the instruction for running a Docker Engine in this website (https://docs.docker.com/engine/installation/binaries/)."
