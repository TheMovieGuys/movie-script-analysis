#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 <output-directory>"
  exit 
fi 
SCRIPT_SRC=./script-links-02.txt
OUTDIR=$1
if [ ! -f $SCRIPT_SRC ]; then
  echo "Script link file [$SCRIPT_SRC] missing."
  exit
fi

REC=`wc -l $SCRIPT_SRC|cut -d' ' -f1`; 
mkdir -p $OUTDIR

for l in `seq 1 $REC`; do 
  SCRIPT_URL=`sed -n "$l"p $SCRIPT_SRC|awk -F "__" '{print($1)}'`
  YR=`sed -n "$l"p $SCRIPT_SRC|awk -F "__" '{print($3)}'|sed 's/ /-/g'`
  TITLE=`sed -n "$l"p $SCRIPT_SRC|awk -F "__" '{print($2)}'|sed 's/ /-/g'`
  OUTPUT_FILE=$OUTDIR/$TITLE.tmp
  echo "Downloading File from [$SCRIPT_URL] to $OUTPUT_FILE"
  wget -q -O $OUTPUT_FILE $SCRIPT_URL
  EXTN=`file $OUTPUT_FILE|cut -d: -f2|sed 's/^ //g'|cut -d' ' -f1`
  rename "s/.tmp/.$EXTN/g" $OUTPUT_FILE
done
