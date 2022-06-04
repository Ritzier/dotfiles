#!/bin/bash

paru -S ./script/pkg_rit.txt
if [ -d $HOME/bin/ ]; then
	ln -s /usr/bin/pyton3.9 $HOME/bin/python3
fi
