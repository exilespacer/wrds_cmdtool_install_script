#!/bin/bash

#reference:
# http://www.linuxfromscratch.org/hints/downloads/files/OLD/apt.txt

set -e

mkdir -p $HOME/local $HOME/tmp
cd $HOME/tmp

wget http://ftp.acc.umu.se/mirror/cdimage/snapshot/Debian/pool/main/d/dpkg/dpkg_1.14.31.tar.gz
tar xvzf dpkg_1.14.31.tar.gz
cd dpkg_1.14.31
./configure --prefix=$HOME/local 

#If you just type 'make,' the compile will fail unless you have jade
#and debiandoc2html (you probably don't have either of these things).
#The best way around this is to change doc/Makefile; this requires
#disabling doc/Makefile:
mv Makefile Makefile.bak
sed 's/^all: /&# /g; s/^install: /&# /g' Makefile.bak > Makefile

make
make install 

rm -rf $HOME/tmp
# still dosn't work
