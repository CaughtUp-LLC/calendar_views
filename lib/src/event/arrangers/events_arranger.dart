import 'package:meta/meta.dart';

import 'package:calendar_views/src/event/events/positionable_event.dart';

import 'arranged_event.dart';
import 'arranger_constraints.dart';

/// Base for a class that arranges events.
abstract class EventsArranger {
  /// Arranges [events] while concerning [constraints] and  returns a list of [ArrangedEvent]s.
  List<ArrangedEvent> arrangeEvents({
    @required Set<PositionableEvent> events,
    @required ArrangerConstraints constraints,
  });
}
