import 'package:meta/meta.dart';

import 'package:calendar_views/src/event/events/positionable_event.dart';

import '../arranged_event.dart';
import '../arranger_constraints.dart';
import '../events_arranger.dart';

/// [EventsArranger] that tries to equally separate overlapping events.
@immutable
class ChainsEventsArranger implements EventsArranger {
  /// Creates a new instance of this class.
  ///
  /// Using some other [eventsSorter] might produce different results.
  const ChainsEventsArranger({
    this.eventsSorter = sortPositionableEvents,
  }) : assert(eventsSorter != null);

  final PositionableEventsSorter eventsSorter;

  @override
  List<ArrangedEvent> arrangeEvents({
    @required Set<PositionableEvent> events,
    @required ArrangerConstraints constraints,
  }) {
    // sorts events
    List<PositionableEvent> sortedEvents;
    sortedEvents = events.toList();
    eventsSorter(sortedEvents);

    // makes all the items
    List<_Item> items = _makeItems(
      sortedEvents,
    );

    // sets overlaps to each item
    for (_Item item in items) {
      _setEarlyOverlaps(item, items);
      _setLateOverlaps(item, items);
      _sortLateOverlaps(item);
    }

    // sets maxRight to each item
    for (_Item item in items) {
      item.maxRight = _calculateMaxRight(item);
    }

    // sets abstractWidth and abstractLeft to each item
    for (_Item itemToPosition in items) {
      if (itemToPosition.earlyOverlaps.isEmpty) {
        setAbstractWidthAndLeft(itemToPosition);
      }
    }

    // converts items to [ArrangedEvent]s
    return items
        .map(
          (item) => new ArrangedEvent(
                top: constraints.positionTopOf(item.start),
                left: item.leftPercentage * constraints.areaWidth,
                width: item.widthPercentage * constraints.areaWidth,
                height: constraints.heightOf(item.duration),
                event: item.event,
              ),
        )
        .toList();
  }
}

/// Creates a list of [_Item]s from [events].
List<_Item> _makeItems(List<PositionableEvent> events) {
  List<_Item> items = <_Item>[];

  for (int i = 0; i < events.length; i++) {
    items.add(
      new _Item(
        id: i,
        event: events[i],
      ),
    );
  }

  return items;
}

/// Sets earlyOverlaps to [item].
void _setEarlyOverlaps(_Item item, List<_Item> otherItems) {
  item.earlyOverlaps = otherItems
      .where(
        (overlapCandidate) =>
            (item != overlapCandidate) &&
            (item.isEarlyOverlapWith(overlapCandidate)),
      )
      .toList();
}

/// Sets lateOverlaps to [item].
void _setLateOverlaps(_Item item, List<_Item> otherItems) {
  item.lateOverlaps = otherItems
      .where((overlapCandidate) =>
          (item != overlapCandidate) &&
          (item.isLateOverlapWith(overlapCandidate)))
      .toList();
}

/// Sorts lateOverlaps of [item].
void _sortLateOverlaps(_Item item) {
  item.lateOverlaps.sort((a, b) {
    int r = a.event.beginMinuteOfDay.compareTo(b.event.beginMinuteOfDay);
    if (r == 0) {
      // same start time (sort by duration, longest first)
      r -= a.event.duration.compareTo(b.event.duration);
      if (r == 0) {
        // same start time and duration (sort by id)
        r = a.id.compareTo(b.id);
      }
    }
    return r;
  });
}

/// Returns maxRight of item.
int _calculateMaxRight(_Item item) {
  if (item.lateOverlaps.isEmpty) {
    return 0;
  } else {
    int maxRight = 0;

    for (_Item lateOverlap in item.lateOverlaps) {
      int right = _calculateMaxRight(lateOverlap);
      if (right > maxRight) {
        maxRight = right;
      }
    }

    maxRight++;
    return maxRight;
  }
}

/// Sets [items] abstractWidth and abstractLeft.
void setAbstractWidthAndLeft(_Item item) {
  double beforeWidth;

  // sets beforeWidth
  if (item.earlyOverlaps.isEmpty) {
    beforeWidth = 0.0;
  } else {
    _Item itemBeforeTheItem;

    for (_Item earlyOverlap in item.earlyOverlaps) {
      if (itemBeforeTheItem == null ||
          earlyOverlap.abstractLeft > itemBeforeTheItem.abstractLeft) {
        itemBeforeTheItem = earlyOverlap;
      }
    }

    beforeWidth =
        itemBeforeTheItem.abstractLeft + itemBeforeTheItem.abstractWidth;
  }

  item.abstractWidth = (100 - beforeWidth) / (1 + item.maxRight);
  item.abstractLeft = beforeWidth;

  item.lateOverlaps.forEach((l) {
    if (l.earlyOverlaps[l.earlyOverlaps.length - 1] == item) {
      setAbstractWidthAndLeft(l);
    }
  });
}

class _Item {
  final int id;

  final PositionableEvent event;

  List<_Item> earlyOverlaps;

  List<_Item> lateOverlaps;

  int maxRight;

  /// between 0 - 100
  double abstractLeft = 0.0;

  double get leftPercentage => abstractLeft / 100;

  /// between 0 - 100
  double abstractWidth = 0.0;

  double get widthPercentage => abstractWidth / 100;

  _Item({
    @required this.id,
    @required this.event,
  })  : assert(id != null),
        assert(event != null);

  int get start => event.beginMinuteOfDay;

  int get end => event.endMinuteOfDay;

  int get duration => event.duration;

  bool isEarlyOverlapWith(_Item other) {
    if (other.start < this.start && other.end > this.start) {
      return true;
    } else if (other.start == this.start) {
      if (other.duration > this.duration) {
        return true;
      } else if (other.duration == this.duration && other.id < this.id) {
        return true;
      }
    }
    return false;
  }

  bool isLateOverlapWith(_Item other) {
    if (other.start > this.start && other.start < this.end) {
      return true;
    } else if (other.start == this.start) {
      if (other.duration < this.duration) {
        return true;
      } else if (other.duration == this.duration && other.id > this.id) {
        return true;
      }
    }
    return false;
  }
}
