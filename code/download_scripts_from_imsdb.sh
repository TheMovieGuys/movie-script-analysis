#!/bin/bash
PREF="http://www.imsdb.com/scripts/"
if [ $# -ne 1 ]; then
  echo "Usage: $0 <output-directory>"
  exit 
fi 
SCRIPT_SRC="script-links-01.txt"
OUTDIR=$1

if [ ! -f $SCRIPT_SRC ]; then
  echo "Script link file [$SCRIPT_SRC] missing."
  exit
fi

REC=`wc -l $SCRIPT_SRC|cut -d' ' -f1`; 
mkdir -p $OUTDIR

for l in `seq 1 5`; do 
  FILE=`sed -n "$l"p $SCRIPT_SRC|tr -s "_" "#"|cut -d\# -f1|sed -e "s/^ //g" -e "s/ /%20/g"` 
  YR=`sed -n "$l"p $SCRIPT_SRC|tr -s "_" "#"|cut -d\# -f3`
  TITLE=`sed -n "$l"p $SCRIPT_SRC|tr -s "_" "#"|cut -d\# -f2|tr -s ' ' '-'`
  echo "Downloading File [$FILE]"
  wget -q -O tmp.htm $FILE
  SCRIPT_FILE=`cat tmp.htm |sed -n '/<p align=\"center\"><a href=\"/,/\" title=\"/{p; /\" title=\"/q}'|cut -d\" -f4`
  SCRIPT_URL=$PREF$SCRIPT_FILE 
  OUTPUT_HTML=$OUTDIR/$TITLE.htm
  echo "Downloading File from [$SCRIPT_URL] to $OUTPUT_HTML"
  wget -q -O $OUTPUT_HTML $SCRIPT_URL
done
