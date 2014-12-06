Zephir Symfony Stopwatch
========================

Edit
-------
Made a few changes to the files

1. Removed comments (causing errors)
2. Removed $
3. Changed namespace 

start a zephir init
```
$ zephir init symftest
$ cd symftest
$ mkdir stopwatch
```
to build project put project in the following folder
```
ext/
symftest/
  stopwatch/
    section.zep
    stopwatch.zep
    stowatchevent.zep
    stopwatchperiod.zep
```
then proceed to build
```bash
$ zephir build
```

[The Symfony's Stopwatch Component](http://symfony.com/doc/current/components/stopwatch.html) delivered as a C extension with the gracefull help of [Zephir](http://zephir-lang.com/).

Install
-------

```bash
sudo docker build - < dockerfile
k=`sudo docker images -q | head -n1`
sudo docker run -v=$PWD:/root -i -t $k /bin/bash
cd /root/
make compile
```

Example
-------

```bash
php << 'EOF'
<?php

use Symfony\Component\Stopwatch\Stopwatch;
use Symfony\Component\Stopwatch\StopwatchEvent;
use Symfony\Component\Stopwatch\StopwatchPeriod;

$stopwatch = new Stopwatch();
$stopwatch->start('eventA');
usleep(200000);
$stopwatch->start('eventB');
usleep(200000);
$eventA = $stopwatch->stop('eventA');
$eventB = $stopwatch->stop('eventB');

printf("Duration of event A: %u ms.\n", $eventA->getDuration());
printf("Duration of event B: %u ms.\n", $eventB->getDuration());

EOF
```

Testing
-------

```bash
make test
```
