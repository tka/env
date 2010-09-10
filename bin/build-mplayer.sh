#!/bin/sh
sudo apt-get remove mplayer
sudo apt-get build-dep mplayer
sudo apt-get install subversion yasm checkinstall
if [ ! -e mplayer ]; then
  svn checkout svn://svn.mplayerhq.hu/mplayer/trunk mplayer
fi
cd mplayer
#svn update
./configure
make -j2
sudo checkinstall

