import 'dart:async';

import 'package:meta/meta.dart';

import 'package:calendar_views/src/internal_date_items/all.dart';
import 'package:calendar_views/src/event/events/positionable_event.dart';
import 'package:calendar_views/src/event/calendar_events/events_of_day_retriever.dart';

typedef void OnEventsFetchCompleted(
  Date date,
  Set<PositionableEvent> events,
);

class EventsFetcher {
  EventsFetcher({
    @required EventsOfDayRetriever eventsRetriever,
    @required this.onFetchCompleted,
  })  : _daysForWhichCurrentlyFetching = new Set(),
        assert(eventsRetriever != null),
        assert(onFetchCompleted != null);

  final OnEventsFetchCompleted onFetchCompleted;

  EventsOfDayRetriever _eventsRetriever;

  final Set<Date> _daysForWhichCurrentlyFetching;

  void changeRetriever(EventsOfDayRetriever newRetriever) {
    _eventsRetriever = newRetriever;
  }

  void fetchEventsOf(Date date) {
    if (!isFetchingEventsOf(date)) {
      _startFetching(date);
    }
  }

  bool isFetchingEventsOf(Date date) {
    return _daysForWhichCurrentlyFetching.contains(date);
  }

  void _startFetching(Date date) {
    _markFetching(date);
    _fetch(date);
  }

  Future _fetch(Date date) async {
    Set<PositionableEvent> fetchedEvents;

    fetchedEvents = await _eventsRetriever.retrieveEventsOfDat(
      date.toDateTime(),
    );

    _onFetchCompleted(date, fetchedEvents);
  }

  void _onFetchCompleted(Date date, Set<PositionableEvent> events) {
    _markNotFetching(date);
    onFetchCompleted(date, events);
  }

  void _markFetching(Date date) {
    _daysForWhichCurrentlyFetching.add(date);
  }

  void _markNotFetching(Date date) {
    _daysForWhichCurrentlyFetching.remove(date);
  }
}
