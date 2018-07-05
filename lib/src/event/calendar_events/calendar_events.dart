library calendar_events;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/src/event/events_manager/all.dart';
import 'package:calendar_views/src/event/events/positionable_event.dart';

part 'events_changed_notifier.dart';

part 'events_provider.dart';

part 'events_refresher.dart';

class CalendarEvents extends StatefulWidget {
  CalendarEvents({
    @required this.eventsRetriever,
    @required this.child,
  })  : assert(eventsRetriever != null),
        assert(child != null);

  final EventsOfDayRetriever eventsRetriever;

  final Widget child;

  @override
  _CalendarEventsState createState() => new _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  EventsManager _eventsManager;

  @override
  void initState() {
    super.initState();

    _eventsManager = new EventsManager(
      eventsRetriever: widget.eventsRetriever,
    );
  }

  @override
  void didUpdateWidget(CalendarEvents oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.eventsRetriever != oldWidget.eventsRetriever) {
      _eventsManager.changeEventsRetriever(widget.eventsRetriever);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new EventsProvider(
      getEventsOf: _eventsManager.getEventsOf,
      child: new EventsRefresher(
        refreshEventsOf: _eventsManager.refreshEventsOf,
        refreshAllEvents: _eventsManager.refreshAllEvents,
        child: new EventsChangedNotifier(
          attach: _eventsManager.attachEventsChangedListener,
          detach: _eventsManager.detachEventsChangedListener,
          child: widget.child,
        ),
      ),
    );
  }
}
