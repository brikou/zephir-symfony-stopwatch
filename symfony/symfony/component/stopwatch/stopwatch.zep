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
 * Stopwatch provides a way to profile code.
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
class Stopwatch
{
    /**
     * @var Section[]
     */
    private $sections;

    /**
     * @var array
     */
    private $activeSections;

    public function __construct()
    {
        let $this->sections = ["__root__": new \Symfony\Component\Stopwatch\Section("__root__")];
        let $this->activeSections = $this->sections;
    }

    /**
     * Creates a new section or re-opens an existing section.
     *
     * @param string|null $id The id of the session to re-open, null to create a new one
     *
     * @throws \LogicException When the section to re-open is not reachable
     */
    public function openSection($id = null) -> void
    {
        var $current;

        let $current = end($this->activeSections);

        if (!is_null($id) && is_null($current->get($id))) {
            throw new \LogicException(sprintf("The section \"%s\" has been started at an other level and can not be opened.", $id));
        }

        $this->start("__section__.child", "section");
        let $this->activeSections[] = $current->open($id);
        $this->start("__section__");
    }

    /**
     * Stops the last started section.
     *
     * The id parameter is used to retrieve the events from this section.
     *
     * @see getSectionEvents
     *
     * @param string $id The identifier of the section
     *
     * @throws \LogicException When there's no started section to be stopped
     */
    public function stopSection($id) -> void
    {
        var $section;

        $this->stop("__section__");

        if (1 == count($this->activeSections)) {
            throw new \LogicException("There is no started section to stop.");
        }

        let $section = array_pop($this->activeSections);
        let $this->sections[$id] = $section->setId($id);
        $this->stop("__section__.child");
    }

    /**
     * Starts an event.
     *
     * @param string $name     The event name
     * @param string $category The event category
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function start(string $name, $category = null) -> <Symfony\Component\Stopwatch\StopwatchEvent>
    {
        var $activeSection;

        let $activeSection = end($this->activeSections);

        return $activeSection->startEvent($name, $category);
    }

    /**
     * Checks if the event was started
     *
     * @param string $name The event name
     *
     * @return bool
     */
    public function isStarted(string $name) -> boolean
    {
        var $activeSection;

        let $activeSection = end($this->activeSections);

        return $activeSection->isEventStarted($name);
    }

    /**
     * Stops an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function stop(string $name) -> <Symfony\Component\Stopwatch\StopwatchEvent>
    {
        var $activeSection;

        let $activeSection = end($this->activeSections);

        return $activeSection->stopEvent($name);
    }

    /**
     * Stops then restarts an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function lap(string $name) -> <Symfony\Component\Stopwatch\StopwatchEvent>
    {
        var $activeSection, $event;

        let $activeSection = end($this->activeSections);
        let $event = $activeSection->stopEvent($name);

        return $event->start();
    }

    /**
     * Gets all events for a given section.
     *
     * @param string $id A section identifier
     *
     * @return StopwatchEvent[] An array of StopwatchEvent instances
     */
    public function getSectionEvents(string $id) -> <Array>
    {
        var $sections, $section;

        if array_key_exists($id, $this->sections) {
            let $sections = $this->sections;
            let $section = $sections[$id];

            return $section->getEvents();
        }

        return [];
    }
}
