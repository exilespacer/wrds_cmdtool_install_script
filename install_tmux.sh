#!/bin/bash

# reference: 
# https://gist.github.com/rothgar/719ef460efc214c8d222
# http://pyther.net/2014/03/building-tmux-1-9a-statically/

TMUX_VERSION="2.1"
LIBEVENT_VERSION="2.0.20"
NCURSES_VERSION="6.0"
GLIBC_VERSION="2.24"

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget https://github.com/downloads/libevent/libevent/libevent-${LIBEVENT_VERSION}-stable.tar.gz
wget http://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
wget https://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_VERSION}.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-${LIBEVENT_VERSION}-stable.tar.gz
cd libevent-${LIBEVENT_VERSION}-stable
./configure --prefix=$HOME/local --disable-shared
make
make install
cd ..

############
# glibc-static
###########
# http://pyther.net/2014/03/building-tmux-1-9a-statically/
tar xvzf glibc-${GLIBC_VERSION}.tar.gz
mkdir glibc-build
cd glibc-build
../glibc-2.24/configure --prefix=$HOME/local
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-${NCURSES_VERSION}.tar.gz
cd ncurses-${NCURSES_VERSION}
./configure --prefix=$HOME/local --with-default-terminfo-dir=$HOME/local/share/terminfo --with-terminfo-dirs="$HOME/local/etc/terminfo:$HOME/local/share/terminfo" CPPFLAGS="-I$HOME/local/include/ncurses"
make
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}

./configure --prefix=$HOME/local --enable-static CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include" LIBEVENT_CFLAGS="-I$HOME/local/include" LIBEVENT_LIBS="-L$HOME/local/lib -levent"

# CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make -j5
make

cp tmux $HOME/local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
