#!/bin/zsh
pakcer -S python-powerline-git libyaml xclip mplayer

echo "##### init config #####"
cd config
for f in * ; do
	echo $f
	ln -sf `pwd`/$f ~/.$f
done;
cd -
