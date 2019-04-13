#!/bin/bash

BASEDIR=$(cd $(dirname $0)/.. && pwd)
SCRIPTDIR=$BASEDIR/scripts
RESULTDIR=$BASEDIR/results
PHPDIR=$BASEDIR/php-src

mkdir -p $RESULTDIR

# Synchronize with the remote repository and retrive all commit ids.

COMMITS=$RESULTDIR/commits.csv
pushd $PHPDIR
  git checkout jit-dynasm --force
  git pull --ff-only origin jit-dynasm
  git log --no-merges --reverse --pretty=format:"%h %cd %s" --date=local origin/master.. >$COMMITS
popd

# Use at most one commit by day for the benchmarking below,
# because using all commits takes too long time.

BYDATE=$RESULTDIR/commits_by_date.csv
cat $COMMITS |\
awk '
  BEGIN {
    prevline = ""
  }
  NR > 1 && $3 $4 != prevdate {
    print prevline;
  }
  {
    prevdate = $3 $4;
    prevline = $0;
  }
  END {
    print prevline;
  }' >$BYDATE

# For each commit retrieved above, compile PHP and run the benchmark on it.
# Benchmarking itself is delegated to run_bench.sh.

cut -f1 -d' ' $BYDATE | while read commit; do
  OUTFILE=$RESULTDIR/result-jit-$commit.out
  if [ -f "$OUTFILE" ]; then
    echo "$commit: benchmark result already exists. skipped."
    continue
  fi
  echo "$commit: checkout and run benchmarks."
  pushd $PHPDIR
    git checkout $commit --force
    make clean distclean
    ./buildconf && ./configure && make
  popd
  if [ -f "$PHPDIR/sapi/cli/php" ]; then
    $SCRIPTDIR/run_bench.sh $OUTFILE
  fi
done

# Cleanup.

pushd $PHPDIR
  git checkout jit-dynasm --force
  make clean distclean
popd
