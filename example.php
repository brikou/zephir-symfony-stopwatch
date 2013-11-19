<?php

require __DIR__.'/vendor/autoload.php';

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
