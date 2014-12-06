namespace Symftest\Stopwatch;

class Stopwatch
{
    private sections;

    private activeSections;

    public function __construct()
    {
        let this->sections = ["__root__": new \Symftest\Stopwatch\Section("__root__")];
        let this->activeSections = this->sections;
    }

    public function openSection(id = null) -> void
    {
        var current;

        let current = end(this->activeSections);

        if (!is_null(id) && is_null(current->get(id))) {
            throw new \LogicException(sprintf("The section \"%s\" has been started at an other level and can not be opened.", id));
        }

        this->start("__section__.child", "section");
        let this->activeSections[] = current->open(id);
        this->start("__section__");
    }

    public function stopSection(id) -> void
    {
        var section;

        this->stop("__section__");

        if (1 == count(this->activeSections)) {
            throw new \LogicException("There is no started section to stop.");
        }

        let section = array_pop(this->activeSections);
        let this->sections[id] = section->setId(id);
        this->stop("__section__.child");
    }

    public function start(string name, category = null)
    {
        var activeSection;

        let activeSection = end(this->activeSections);

        return activeSection->startEvent(name, category);
    }

    public function isStarted(string name) -> boolean
    {
        var activeSection;

        let activeSection = end(this->activeSections);

        return activeSection->isEventStarted(name);
    }

    public function stop(string name)
    {
        var activeSection;

        let activeSection = end(this->activeSections);

        return activeSection->stopEvent(name);
    }

    public function lap(string name)
    {
        var activeSection, event;

        let activeSection = end(this->activeSections);
        let event = activeSection->stopEvent(name);

        return event->start();
    }


    public function getSectionEvents(string id)
    {
        var sections, section;

        if array_key_exists(id, this->sections) {
            let sections = this->sections;
            let section = sections[id];

            return section->getEvents();
        }

        return [];
    }
}
