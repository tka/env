#!/bin/sh
sudo yes | apt-get build-dep mplayer ffmpeg
sudo yes | apt-get remove mplayer ffmpeg x264 libx264-dev

sudo yes | apt-get install subversion yasm checkinstall \
    build-essential subversion git-core checkinstall yasm texi2html \
    libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev \
    libtheora-dev libvorbis-dev libvpx-dev libx11-dev libxfixes-dev libxvidcore-dev \
    zlib1g-dev

if [ ! -e x264 ]; then
  git clone git://git.videolan.org/x264.git
fi

cd x264
./configure --enable-shared
make -j2
sudo checkinstall --pkgname=x264 --pkgversion "2:0.`grep X264_BUILD x264.h -m1 | \
      cut -d' ' -f3`.`git rev-list HEAD | wc -l`+git`git rev-list HEAD -n 1 | \
          head -c 7`" --backup=no --deldoc=yes --fstrans=no --default
cd ..

if [ ! -e ffmpeg ]; then
  svn checkout svn://svn.ffmpeg.org/ffmpeg/trunk ffmpeg
fi 

./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc \
      --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb \
      --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis \
      --enable-libvpx --enable-libx264 --enable-libxvid --enable-x11grab
make -j2
sudo checkinstall --pkgname=ffmpeg --pkgversion "4:SVN-r`LANG=C svn info | \
      grep Revision | awk '{ print $NF }'`" --backup=no --deldoc=yes --fstrans=no \
          --default
hash x264 ffmpeg ffplay
cd ..

if [ ! -e mplayer ]; then
  svn checkout svn://svn.mplayerhq.hu/mplayer/trunk mplayer
fi
cd mplayer
./configure
make -j2
sudo checkinstall

