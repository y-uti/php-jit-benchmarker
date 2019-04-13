#!/bin/bash

BASEDIR=$(cd $(dirname $0)/.. && pwd)
SCRIPTDIR=$BASEDIR/scripts
RESULTDIR=$BASEDIR/results
PHPDIR=$BASEDIR/php-src

OUTFILE=$1
NRUNS=10

for i in $(seq 1 $NRUNS); do
  $PHPDIR/sapi/cli/php \
    -dzend_extension=$PHPDIR/modules/opcache.so \
    -dopcache.enable_cli=1 \
    -dopcache.jit_buffer_size=32M \
    $PHPDIR/Zend/bench.php
done >$OUTFILE

# Output benchmark, elapsed time, and trial number.
# TODO: ugly. the magic number relies on that the benchmark consists of 18 tests.

grep '^[a-zT]' $OUTFILE |\
  awk '{ printf("%s,%s,%d\n", $1, $2, (NR + 18) / 19) }' \
  >${OUTFILE%.out}.csv
