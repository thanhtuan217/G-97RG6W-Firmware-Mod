const dateFromTimestamp = function(timestamp) {
    return new Date(timestamp * 1000).toLocaleString();
};

const eventComparison = function(a, b) {
    if (a.timestamp > b.timestamp) {
        return 1;
    }
    if (a.timestamp < b.timestamp) {
        return -1;
    }
    if (a.usec > b.usec) {
        return 1;
    }
    if (a.usec < b.usec) {
        return -1;
    }
    return 0;
};

class EventsView {

    constructor()
    {
        this.view = document.getElementById('events');
        this.eventsList = document.getElementById('events-list');
        this.eventsStatistics = document.getElementById('events-statistics');
        this.eventsTotalCount = document.getElementById('events-total-count');
        this.eventsRefresh = document.getElementById('events-refresh');
        this.eventsRefreshCounters = document.getElementById('events-refresh-counters');
        this.eventsDeleteAll = document.getElementById('events-delete-all');
        this.eventsResetCounters = document.getElementById('events-reset-counters');

        this.titleList = document.getElementById('events-title-list');
        this.titleStatistics = document.getElementById('events-title-statistics');

        this.list = document.getElementById('events-list-container');
        this.statistics = document.getElementById('events-statistics-container');

        this.titleList.addEventListener('click', () => {
            this.showList();
        });
        this.titleStatistics.addEventListener('click', () => {
            this.showStatistics();
        });

        this.state = {
            events: [],
            total: "",
            counters: {},
            updateEventsCallback: null,
            updateCountersCallback: null
        };

    }

    show()
    {
        this.showList();
        this.view.style.display = 'block';
    }

    hide()
    {
        this.view.style.display = 'none';
    }

    showList()
    {
        this.list.style.display = 'block';
        this.statistics.style.display = 'none';
        this.titleList.style.fontWeight = 'bold';
        this.titleList.style.color = '#00baff';
        this.titleStatistics.style.fontWeight = 'normal';
        this.titleStatistics.style.color = 'black';
        if (this.state.updateEventsCallback) {
            this.state.updateEventsCallback();
        }
    }

    showStatistics()
    {
        this.list.style.display = 'none';
        this.statistics.style.display = 'block';
        this.titleList.style.fontWeight = 'normal';
        this.titleList.style.color = 'black';
        this.titleStatistics.style.fontWeight = 'bold';
        this.titleStatistics.style.color = '#00baff';
        if (this.state.updateCountersCallback) {
            this.state.updateCountersCallback();
        }
    }

    setRefreshListOnClick(callback)
    {
        this.eventsRefresh.addEventListener('click', callback);
        this.state.updateEventsCallback = callback;
    }

    setRefreshCountersOnClick(callback)
    {
        this.eventsRefreshCounters.addEventListener('click', callback);
        this.state.updateCountersCallback = callback;
    }

    setDeleteAllOnClick(callback)
    {
        this.eventsDeleteAll.addEventListener('click', callback);
    }

    setResetCountersOnClick(callback)
    {
        this.eventsResetCounters.addEventListener('click', callback);
    }

    setEvents(events)
    {
        this.state.events = events;
        this.state.events.sort(eventComparison);
        this.updateEvents();
    }

    addEvents(events)
    {
        this.state.events = this.state.events.concat(events);
        this.state.events.sort(eventComparison);
        this.updateEvents();
    }

    setCounters(countersData)
    {
        if (Object.keys(countersData).length == 0) {
            this.state.counters = {};
            this.state.total = "0";
        } else {
            this.state.counters = countersData.counters;
            this.state.total = countersData.total;
        }
        this.updateCounters();
    }

    getLatestId()
    {
        let id = "";
        if (this.state.events.length) {
            id = this.state.events[this.state.events.length - 1].id;
        }
        return id;
    }

    updateEvents()
    {
        this.clearEvents();

        if (this.state.events.length == 0) {
            const template = document.getElementById('event-template');
            const item = document.importNode(template.content, true);

            const msg = item.querySelector('.date');
            msg.textContent = 'No events found.';

            this.eventsList.appendChild(item);
            return;
        }

        for (const event of this.state.events) {
            const template = document.getElementById('event-template');
            const item = document.importNode(template.content, true);

            const date = item.querySelector('.date');
            const type = item.querySelector('.type');
            const mac = item.querySelector('.mac');
            const argument = item.querySelector('.argument');

            date.textContent = dateFromTimestamp(event.timestamp);
            type.textContent = event.type;

            mac.textContent = event.args[0];
            argument.textContent = event.args[1];
            argument.title = event.args[1];

            this.eventsList.appendChild(item);
        }
    }

    clearEvents()
    {
        this.eventsList.innerHTML = '';
    }

    updateCounters()
    {
        this.clearCounters();

        this.eventsTotalCount.textContent = this.state.total;

        if (Object.keys(this.state.counters).length == 0) {
            const template = document.getElementById('event-counter-template');
            const item = document.importNode(template.content, true);       
            const msg = item.querySelector('.type');
            msg.textContent = 'No counters found.';
            this.eventsStatistics.appendChild(item);
            return;
        }

        for (const counter in this.state.counters) {
            const template = document.getElementById('event-counter-template');
            const item = document.importNode(template.content, true);

            const type = item.querySelector('.type');
            const count = item.querySelector('.count');

            type.textContent = counter;
            count.textContent = this.state.counters[counter];

            this.eventsStatistics.appendChild(item);
        }
    }

    clearCounters()
    {
        this.eventsStatistics.innerHTML = '';
    }
}

export default EventsView;
