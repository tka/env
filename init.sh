#!/bin/zsh

echo "##### init config #####"
cd config
for f in * ; do
	echo $f
	cp $f ~/.$f
done;
cd -
