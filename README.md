# php-jit-benchmarker

Scripts for measuring the performance improvement achived by JIT-for-PHP (https://github.com/zendtech/php-src)

*The result by running this script does NOT indicate any performance of real-life applications. It should be regarded as a micro-benchmark.*

## Usage

### Clone this repository and enter to the directory

```
$ git clone https://github.com/y-uti/php-jit-benchmarker.git
$ cd php-jit-benchmarker
```

### Clone the repository where JIT-for-PHP has been developped

```
$ git clone https://github.com/zendtech/php-src.git
```

### Run the script

```
$ ./scripts/do_all.sh
```

The script takes long time (so I prefer to run it background), but you'll get results in `results` directory.

Note: the script will consume much CPU resource continuously, because it build PHP repeatedly.

### Aggregate all results

```
$ ./scripts/aggregate.sh
```

You'll get `all.csv` in `results` directory.
