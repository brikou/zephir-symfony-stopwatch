namespace Symftest\Stopwatch;

class Section
{

    private events;

    private origin;

    private id;

    private children;

    public function __construct(origin = null)
    {
        let this->events = [];
        let this->children = [];
        if is_numeric(origin) {
            let this->origin = origin;
        } else {
            let this->origin = null;
        }
    }

    public function get(string id)
    {
        var child;

        for child in this->children {
            if (id === child->getId()) {
                return child;
            }
        }

        return null;
    }

    public function open(id)
    {
        var session;

        let session = this->get(id);
        if is_null(session) {
            let session = new self(microtime(true) * 1000);
            let this->children[] = session;
        }

        return session;
    }

    public function getId() -> string
    {
        return this->id;
    }

    public function setId(string id)
    {
        let $this->id = id;

        return this;
    }

    public function startEvent(string name, string category)
    {
        var origin;

        if !array_key_exists(name, this->events) {

            if is_null(this->origin) {
                let origin = microtime(true) * 1000;
            } else {
                let origin = this->origin;
            }

            let this->events[name] = new \Symftest\Stopwatch\StopwatchEvent(origin, category);
        }

        return this->events[name]->start();
    }

    public function isEventStarted(string name) -> boolean
    {
        if !array_key_exists(name, this->events) {
            return false;
        }

        return this->events[name]->isStarted();
    }

    public function stopEvent(string name)
    {
        if !array_key_exists(name, this->events) {
            throw new \LogicException(sprintf("Event \"%s\" is not started.", $name));
        }

        return this->events[name]->stop();
    }

    public function lap(string name)
    {
        var event;

        let event = this->stopEvent($name);

        return event->start();
    }

    public function getEvents()
    {
        return this->events;
    }
}
