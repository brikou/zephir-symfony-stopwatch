/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Symfony\Component\Stopwatch;

/**
 * Represents an Event managed by Stopwatch.
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
class StopwatchEvent
{
    /**
     * @var StopwatchPeriod[]
     */
    private $periods;

    /**
     * @var float
     */
    private $origin;

    /**
     * @var string
     */
    private $category;

    /**
     * @var float[]
     */
    private $started;

    /**
     * Constructor.
     *
     * @param float  $origin   The origin time in milliseconds
     * @param string $category The event category
     *
     * @throws \InvalidArgumentException When the raw time is not valid
     */
    public function __construct($origin, $category = null)
    {
        let $this->origin = $this->formatTime($origin);
        if is_string($category) {
            let this->category = $category;
        } else {
            let this->category = "default";
        }
        let $this->started = [];
        let $this->periods = [];
    }

    /**
     * Gets the category.
     *
     * @return string The category
     */
    public function getCategory() -> string
    {
        return $this->category;
    }

    /**
     * Gets the origin.
     *
     * @return integer The origin in milliseconds
     */
    public function getOrigin() -> uint
    {
        return $this->origin;
    }

    /**
     * Starts a new event period.
     *
     * @return StopwatchEvent The event
     */
    public function start() -> <Symfony\Component\Stopwatch\StopwatchEvent>
    {
        let $this->started[] = $this->getNow();

        return $this;
    }

    /**
     * Stops the last started event period.
     *
     * @throws \LogicException When start wasn't called before stopping
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When stop() is called without a matching call to start()
     */
    public function stop() -> <Symfony\Component\Stopwatch\StopwatchEvent>
    {
        if (!count($this->started)) {
            throw new \LogicException("stop() called but start() has not been called before.");
        }

        array_push($this->periods, new \Symfony\Component\Stopwatch\StopwatchPeriod(array_pop($this->started), $this->getNow()));

        return $this;
    }

    /**
     * Checks if the event was started
     *
     * @return bool
     */
    public function isStarted() -> boolean
    {
        return count($this->started) > 0;
    }

    /**
     * Stops the current period and then starts a new one.
     *
     * @return StopwatchEvent The event
     */
    public function lap() -> <Symfony\Component\Stopwatch\StopwatchEvent>
    {
        return $this->stop()->start();
    }

    /**
     * Stops all non already stopped periods.
     */
    public function ensureStopped() -> void
    {
        while (count($this->started)) {
            $this->stop();
        }
    }

    /**
     * Gets all event periods.
     *
     * @return StopwatchPeriod[] An array of StopwatchPeriod instances
     */
    public function getPeriods()
    {
        return $this->periods;
    }

    /**
     * Gets the relative time of the start of the first period.
     *
     * @return integer The time (in milliseconds)
     */
    public function getStartTime() -> uint
    {
        var $period;

        let $period = reset($this->periods);

        if $period {
            return $period->getStartTime();
        }

        return 0;
    }

    /**
     * Gets the relative time of the end of the last period.
     *
     * @return integer The time (in milliseconds)
     */
    public function getEndTime() -> uint
    {
        var $period;

        let $period = end($this->periods);

        if $period {
            return $period->getEndTime();
        }

        return 0;
    }

    /**
     * Gets the duration of the events (including all periods).
     *
     * @return integer The duration (in milliseconds)
     */
    public function getDuration() -> uint
    {
        var $period;
        uint $total = 0;

        for $period in $this->periods {
            let $total += $period->getDuration();
        }

        return $this->formatTime($total);
    }

    /**
     * Gets the max memory usage of all periods.
     *
     * @return integer The memory usage (in bytes)
     */
    public function getMemory()
    {
        var $period, $memory = 0;

        for $period in $this->periods {
            if ($period->getMemory() > $memory) {
                let $memory = $period->getMemory();
            }
        }

        return $memory;
    }

    /**
     * Return the current time relative to origin.
     *
     * @return float Time in ms
     */
    protected function getNow() -> float
    {
        uint $time;

        let $time = microtime(true) * 1000;
        let $time -= $this->origin;

        return $this->formatTime($time);
    }

    /**
     * Formats a time.
     *
     * @param integer|float $time A raw time
     *
     * @return float The formatted time
     *
     * @throws \InvalidArgumentException When the raw time is not valid
     */
    private function formatTime($time) -> float
    {
        if (!is_numeric($time)) {
            throw new \InvalidArgumentException("The time must be a numerical value");
        }

        return round($time, 1);
    }
}
