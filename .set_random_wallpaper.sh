#!/bin/sh

bash ~/.fehbg
PDATE=`date +"%s"`

while true
do
  NDATE=`date --date='-1 minutes' +"%s"`
  sleep 1

 if [ $PDATE -eq $NDATE ];
  then
    bash ~/.fehbg
    PDATE=`date +"%s"`
    echo 'update'
  fi  
done
