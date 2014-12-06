/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace symftest\Stopwatch;

/**
 * @internal This class is for internal usage only
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
class Section
{
    /**
     * @var StopwatchEvent[]
     */
    private events;

    /**
     * @var null|float
     */
    private origin;

    /**
     * @var string
     */
    private id;

    /**
     * @var Section[]
     */
    private children;

    /**
     * Constructor.
     *
     * @param float|null $origin Set the origin of the events in this section, use null to set their origin to their start time
     */
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

    /**
     * Returns the child section.
     *
     * @param string $id The child section identifier
     *
     * @return Section|null The child section or null when none found
     */
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

    /**
     * Creates or re-opens a child section.
     *
     * @param string|null $id null to create a new section, the identifier to re-open an existing one.
     *
     * @return Section A child section
     */
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

    /**
     * @return string The identifier of the section
     */
    public function getId() -> string
    {
        return this->id;
    }

    /**
     * Sets the session identifier.
     *
     * @param string id The session identifier
     *
     * @return Section The current section
     */
    public function setId(string id)
    {
        let $this->id = id;

        return this;
    }

    /**
     * Starts an event.
     *
     * @param string $name     The event name
     * @param string $category The event category
     *
     * @return StopwatchEvent The event
     */
    public function startEvent(string name, string category)
    {
        var origin;

        if !array_key_exists(name, this->events) {

            if is_null(this->origin) {
                let origin = microtime(true) * 1000;
            } else {
                let origin = this->origin;
            }

            let this->events[name] = new \symftest\Stopwatch\StopwatchEvent(origin, category);
        }

        return this->events[name]->start();
    }

    /**
     * Checks if the event was started
     *
     * @param string $name The event name
     *
     * @return bool
     */
    public function isEventStarted(string name) -> boolean
    {
        if !array_key_exists(name, this->events) {
            return false;
        }

        return this->events[name]->isStarted();
    }

    /**
     * Stops an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When the event has not been started
     */
    public function stopEvent(string name)
    {
        if !array_key_exists(name, this->events) {
            throw new \LogicException(sprintf("Event \"%s\" is not started.", $name));
        }

        return this->events[name]->stop();
    }

    /**
     * Stops then restarts an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When the event has not been started
     */
    public function lap(string name)
    {
        var event;

        let event = this->stopEvent($name);

        return event->start();
    }

    /**
     * Returns the events from this section.
     *
     * @return StopwatchEvent[] An array of StopwatchEvent instances
     */
    public function getEvents()
    {
        return this->events;
    }
}
