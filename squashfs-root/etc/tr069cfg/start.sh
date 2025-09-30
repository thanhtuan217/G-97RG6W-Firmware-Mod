#!/bin/sh

CDIR="/tmp/cpe3"


CfgDIR="/etc/tr069cfg"
echo CfgDIR = $CfgDIR

# Check to see if $CDIR exists
if   [ -d $CDIR ] ; then
   echo -n " "
elif [ -e $CDIR ] ; then
   rm -rf $CDIR
   mkdir  $CDIR
else
   mkdir  $CDIR
fi

if cd $CDIR ; then
    echo cd $CDIR
else
    echo could not cd to $CDIR
    exit 1
fi

rm -f *.dat

for dir in data filetrans options parameter ; do
 echo dir = $dir 
  if [ -d $dir ] ; then
     rm -f ${dir}/*
  elif [ -e $dir ] ; then
     rm -rf $dir
     mkdir $dir   > /dev/null 2>&1
  else
     mkdir $dir   > /dev/null 2>&1
  fi
  mkdir $dir      > /dev/null 2>&1

done

# copy the dps.param init file to /tmp/cpe3/ for tr069 start. if this step fail then tr069 should not be start.
cd $CfgDIR
echo cdir = $CDIR
cp dps*param $CDIR
cp -rf CA $CDIR
cd /
exit 1 

#end

