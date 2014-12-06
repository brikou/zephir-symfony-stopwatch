namespace Symftest\Stopwatch;

class StopwatchPeriod
{
    private start;
    private end;
    private memory;

    public function __construct(start, end)
    {
        let this->start = start;
        let this->end = end;
        let this->memory = memory_get_usage(true);
    }

    public function getStartTime()
    {
        return this->start;
    }

    public function getEndTime()
    {
        return this->end;
    }

    public function getDuration()
    {
        return this->end - this->start;
    }

    public function getMemory()
    {
        return this->memory;
    }
}
