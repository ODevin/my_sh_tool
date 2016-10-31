#!/usr/bin/env bash
#echo `pwd`
path=`pwd`
dirlist=`ls -F |grep /$`
for dir in $dirlist
do
echo `du -sh ${path}/${dir}`
done
