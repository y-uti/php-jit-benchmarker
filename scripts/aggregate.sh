#!/bin/bash

BASEDIR=$(cd $(dirname $0)/.. && pwd)
RESULTDIR=$BASEDIR/results

cat $RESULTDIR/commits_by_date.csv | while read line; do
  commit=$(echo $line | cut -d' ' -f1)
  dt=$(echo $line | cut -d' ' -f2-6)
  dt=$(date -d "$dt" +"%Y-%m-%d %H:%M:%S")
  cat $RESULTDIR/result-jit-$commit.csv | sed "s/^/$dt,$commit,/"
done >$RESULTDIR/all.csv
