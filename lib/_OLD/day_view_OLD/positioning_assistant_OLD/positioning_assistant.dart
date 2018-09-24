import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/src/day_view/properties/all.dart';
import 'package:calendar_views/src/day_view/day_view/day_view_schedule.dart';

import 'area_OLD.dart';
import 'area_name_OLD.dart';

/// Object that assist in positioning components inside a [DayView].
@immutable
class PositioningAssistant {
  PositioningAssistant({
    @required this.daysData,
    @required this.dimensionsData,
    @required this.restrictionsData,
    @required this.sizeConstraintsData,
  })  : assert(daysData != null),
        assert(dimensionsData != null),
        assert(restrictionsData != null),
        assert(sizeConstraintsData != null);

  final DaysData daysData;
  final DimensionsData dimensionsData;
  final RestrictionsData restrictionsData;
  final SizeConstraintsData sizeConstraintsData;

  /// Height of the area that should be taken by some item that lasts [duration] number of minutes.
  double heightOfDuration(int duration) {
    return dimensionsData.heightPerMinute * duration;
  }

  /// Location (from top) of a specific [minuteOfDay] inside DayView.
  double minuteOfDayFromTop(int minuteOfDay) {
    double location = dimensionsData.topExtensionHeight;
    location += heightOfDuration(
      _minutesFromMinimumMinute(minuteOfDay),
    );
    return location;
  }

  /// Returns the [AreaOLD] of some non-numbered-area.
  AreaOLD getAreaOf(AreaNameOLD areaName) {
    switch (areaName) {
      case AreaNameOLD.totalArea:
        return totalArea;
      case AreaNameOLD.timeIndicationArea:
        return timeIndicationArea;
      case AreaNameOLD.separationArea:
        return separationArea;
      case AreaNameOLD.contentArea:
        return contentArea;
      case AreaNameOLD.eventArea:
        return eventsArea;
      default:
        throw new ArgumentError.value(
          areaName,
          "areaName",
          "This function can only return Area of an non-numbered-area. Try using getNumberedAreaOf",
        );
    }
  }

  /// Returns the [AreaOLD] of some numbered-area
  AreaOLD getNumberedAreaOf(AreaNameOLD areaName, int number) {
    switch (areaName) {
      case AreaNameOLD.dayArea:
        return dayArea(number);
      case AreaNameOLD.daySeparationArea:
        return daySeparationArea(number);
      case AreaNameOLD.extendedDaySeparationArea:
        return extendedDaySeparationArea(number);
      default:
        throw new ArgumentError.value(
          areaName,
          "areaName",
          "This function can only return Area of an numbered-area. Try using getAreaOf",
        );
    }
  }

  // total Area ----------------------------------------------------------------

  AreaOLD get totalArea => new AreaOLD(
        name: AreaNameOLD.totalArea,
        size: totalAreaSize,
        left: totalAreaLeft,
        right: totalAreaRight,
        top: totalAreaTop,
        bottom: totalAreaBottom,
        minuteOfDayFromAreaTop: minuteOfDayFromTopInsideTotalArea,
        heightOfDuration: heightOfDurationInsideTotalArea,
      );

  /// Width that the [DayView] should occupy.
  double get totalAreaWidth => sizeConstraintsData.totalWidth;

  /// Height that the [DayView] should occupy.
  double get totalAreaHeight =>
      dimensionsData.topExtensionHeight +
      heightOfDuration(_totalNumberOfMinutes) +
      dimensionsData.bottomExtensionHeight;

  Size get totalAreaSize => new Size(
        totalAreaWidth,
        totalAreaHeight,
      );

  double get totalAreaLeft => 0.0;

  double get totalAreaRight => totalAreaLeft + totalAreaWidth;

  double get totalAreaTop => 0.0;

  double get totalAreaBottom => totalAreaTop + totalAreaHeight;

  double minuteOfDayFromTopInsideTotalArea(int minuteOfDay) {
    double r = dimensionsData.topExtensionHeight;
    r += heightOfDuration(_minutesFromMinimumMinute(minuteOfDay));
    return r;
  }

  double heightOfDurationInsideTotalArea(int duration) {
    return heightOfDuration(duration);
  }

  // TimeIndication area -------------------------------------------------------

  AreaOLD get timeIndicationArea => new AreaOLD(
        name: AreaNameOLD.timeIndicationArea,
        size: timeIndicationAreaSize,
        left: timeIndicationAreaLeft,
        right: timeIndicationAreaRight,
        top: timeIndicationAreaTop,
        bottom: timeIndicationAreaBottom,
        minuteOfDayFromAreaTop: minuteOfDayFromTopInsideTimeIndicationArea,
        heightOfDuration: heightOfDurationInsideTimeIndicationArea,
      );

  /// Width of TimeIndicationArea.
  double get timeIndicationAreaWidth => dimensionsData.timeIndicationAreaWidth;

  double get timeIndicationAreHeight => totalAreaHeight;

  Size get timeIndicationAreaSize => new Size(
        timeIndicationAreaWidth,
        timeIndicationAreHeight,
      );

  /// Leftmost location of TimeIndicationArea.
  double get timeIndicationAreaLeft => 0.0;

  /// Rightmost location of TimeIndicationArea.
  double get timeIndicationAreaRight =>
      timeIndicationAreaLeft + timeIndicationAreaWidth;

  double get timeIndicationAreaTop => 0.0;

  double get timeIndicationAreaBottom => totalAreaWidth;

  double minuteOfDayFromTopInsideTimeIndicationArea(int minuteOfDay) {
    return minuteOfDayFromTopInsideTotalArea(minuteOfDay);
  }

  double heightOfDurationInsideTimeIndicationArea(int duration) {
    return heightOfDuration(duration);
  }

  // Separation area -----------------------------------------------------------

  AreaOLD get separationArea => new AreaOLD(
        name: AreaNameOLD.separationArea,
        size: separationAreaSize,
        left: separationAreaLeft,
        right: separationAreaRight,
        top: separationAreaTop,
        bottom: separationAreaBottom,
        minuteOfDayFromAreaTop: minuteOfDayFromTopInsideSeparationArea,
        heightOfDuration: heightOfDurationInsideSeparationArea,
      );

  /// Width of SeparationArea.
  double get separationAreaWidth => dimensionsData.separationAreaWidth;

  double get separationAreaHeight => totalAreaHeight;

  Size get separationAreaSize => new Size(
        separationAreaWidth,
        separationAreaHeight,
      );

  /// Leftmost location of SeparationArea.
  double get separationAreaLeft => timeIndicationAreaRight;

  /// Rightmost location of separationArea.
  double get separationAreaRight => separationAreaLeft + separationAreaWidth;

  double get separationAreaTop => 0.0;

  double get separationAreaBottom => totalAreaHeight;

  double minuteOfDayFromTopInsideSeparationArea(int minuteOfDay) {
    return minuteOfDayFromTopInsideTotalArea(minuteOfDay);
  }

  double heightOfDurationInsideSeparationArea(int duration) {
    return heightOfDuration(duration);
  }

  // Content area --------------------------------------------------------------

  AreaOLD get contentArea => new AreaOLD(
        name: AreaNameOLD.contentArea,
        size: contentAreaSize,
        left: contentAreaLeft,
        right: contentAreaRight,
        top: contentAreaTop,
        bottom: contentAreaBottom,
        minuteOfDayFromAreaTop: minuteOfDayFromTopInsideContentArea,
        heightOfDuration: heightOfDurationInsideContentArea,
      );

  /// Width of ContentArea.
  double get contentAreaWidth {
    double r = 0.0;
    r = totalAreaWidth;
    r -= timeIndicationAreaWidth;
    r -= separationAreaWidth;

    if (r < 0) {
      r = 0.0;
    }

    return r;
  }

  double get contentAreaHeight => totalAreaHeight;

  Size get contentAreaSize => new Size(
        contentAreaWidth,
        contentAreaHeight,
      );

  /// Leftmost location of ContentArea.
  double get contentAreaLeft => separationAreaRight;

  double get contentAreaRight => contentAreaLeft + contentAreaWidth;

  double get contentAreaTop => 0.0;

  double get contentAreaBottom => totalAreaHeight;

  double minuteOfDayFromTopInsideContentArea(int minuteOfDay) {
    return minuteOfDayFromTopInsideTotalArea(minuteOfDay);
  }

  double heightOfDurationInsideContentArea(int duration) {
    return heightOfDuration(duration);
  }

  // Events area ---------------------------------------------------------------

  AreaOLD get eventsArea => new AreaOLD(
        name: AreaNameOLD.eventArea,
        size: eventsAreaSize,
        left: eventsAreaLeft,
        right: eventsAreaRight,
        top: eventsAreaTop,
        bottom: eventsAreaBottom,
        minuteOfDayFromAreaTop: minuteOfDayFromTopInsideEventsArea,
        heightOfDuration: heightOfDurationInsideEventsArea,
      );

  /// Width of EventsArea.
  double get eventsAreaWidth {
    double r = 0.0;
    r = totalAreaWidth;
    r -= timeIndicationAreaWidth;
    r -= separationAreaWidth;
    r -= dimensionsData.eventsAreaStartMargin;
    r -= dimensionsData.eventsAreaEndMargin;

    if (r < 0) {
      r = 0.0;
    }

    return r;
  }

  /// Height of the EventsArea.
  double get eventsAreaHeight {
    double r = 0.0;
    r = totalAreaHeight;
    r -= dimensionsData.topExtensionHeight;
    r -= dimensionsData.bottomExtensionHeight;

    if (r < 0) {
      r = 0.0;
    }

    return r;
  }

  Size get eventsAreaSize => new Size(
        eventsAreaWidth,
        eventsAreaHeight,
      );

  /// Leftmost location of EventsArea.
  double get eventsAreaLeft =>
      contentAreaLeft + dimensionsData.eventsAreaStartMargin;

  /// Rightmost location of EventsArea.
  double get eventsAreaRight => eventsAreaLeft + eventsAreaWidth;

  /// Topmost location of EventsArea.
  double get eventsAreaTop => dimensionsData.topExtensionHeight;

  /// Bottommost location of EventsArea.
  double get eventsAreaBottom => eventsAreaTop + eventsAreaHeight;

  double minuteOfDayFromTopInsideEventsArea(int minuteOfDay) {
    return heightOfDuration(
      _minutesFromMinimumMinute(minuteOfDay),
    );
  }

  double heightOfDurationInsideEventsArea(int duration) {
    return heightOfDuration(duration);
  }

  // Day area ------------------------------------------------------------------

  AreaOLD dayArea(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return new AreaOLD(
      name: AreaNameOLD.dayArea,
      size: dayAreaSize(dayNumber),
      left: dayAreaLeft(dayNumber),
      right: dayAreaRight(dayNumber),
      top: dayAreaTop(dayNumber),
      bottom: dayAreaBottom(dayNumber),
      minuteOfDayFromAreaTop: (int minuteOfDay) => minuteOfDayFromTopInsideDayArea(
            dayNumber,
            minuteOfDay,
          ),
      heightOfDuration: (int duration) => heightOfDurationInsideDayArea(
            dayNumber,
            duration,
          ),
    );
  }

  double dayAreaWidth(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    double r = eventsAreaWidth;
    // remove separation between days
    r -= (_numberOfDays - 1) * dimensionsData.daySeparationAreaWidth;
    // divide the rest of the are between days
    r /= _numberOfDays;

    if (r < 0) {
      r = 0.0;
    }

    return r;
  }

  double dayAreaHeight(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return eventsAreaHeight;
  }

  Size dayAreaSize(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return new Size(
      dayAreaWidth(dayNumber),
      dayAreaHeight(dayNumber),
    );
  }

  double dayAreaLeft(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    double r = eventsAreaLeft;
    r += dimensionsData.daySeparationAreaWidth * dayNumber;
    r += dayAreaWidth(dayNumber) * dayNumber;
    return r;
  }

  double dayAreaRight(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    double r = dayAreaLeft(dayNumber);
    r += dayAreaWidth(dayNumber);
    return r;
  }

  double dayAreaTop(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return eventsAreaTop;
  }

  double dayAreaBottom(int dayNumber) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return eventsAreaBottom;
  }

  double minuteOfDayFromTopInsideDayArea(int dayNumber, int minuteOfDay) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return minuteOfDayFromTopInsideEventsArea(minuteOfDay);
  }

  double heightOfDurationInsideDayArea(int dayNumber, int duration) {
    _throwArgumentErrorIfInvalidDayNumber(dayNumber);

    return heightOfDuration(duration);
  }

  // Day Separation Area -------------------------------------------------------

  AreaOLD daySeparationArea(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return new AreaOLD(
      name: AreaNameOLD.daySeparationArea,
      size: daySeparationAreaSize(daySeparationNumber),
      left: daySeparationAreaLeft(daySeparationNumber),
      right: daySeparationAreaRight(daySeparationNumber),
      top: daySeparationAreaTop(daySeparationNumber),
      bottom: daySeparationAreaBottom(daySeparationNumber),
      minuteOfDayFromAreaTop: (int minuteOfDay) =>
          minuteOfDayFromTopInsideDaySeparationArea(
            daySeparationNumber,
            minuteOfDay,
          ),
      heightOfDuration: (int duration) =>
          heightOfDurationInsideDaySeparationArea(
            daySeparationNumber,
            duration,
          ),
    );
  }

  double daySeparationAreaWidth(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return dimensionsData.daySeparationAreaWidth;
  }

  double daySeparationAreaHeight(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return eventsAreaHeight;
  }

  Size daySeparationAreaSize(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return new Size(
      daySeparationAreaWidth(daySeparationNumber),
      daySeparationAreaHeight(daySeparationNumber),
    );
  }

  double daySeparationAreaLeft(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return dayAreaRight(daySeparationNumber);
  }

  double daySeparationAreaRight(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    double r = 0.0;
    r = daySeparationAreaLeft(daySeparationNumber);
    r += daySeparationAreaWidth(daySeparationNumber);
    return r;
  }

  double daySeparationAreaTop(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return eventsAreaTop;
  }

  double daySeparationAreaBottom(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return eventsAreaBottom;
  }

  double minuteOfDayFromTopInsideDaySeparationArea(
    int daySeparationNumber,
    int minuteOfDay,
  ) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return minuteOfDayFromTopInsideDayArea(daySeparationNumber, minuteOfDay);
  }

  double heightOfDurationInsideDaySeparationArea(
    int daySeparationNumber,
    int duration,
  ) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return heightOfDuration(duration);
  }

  // Extended Day Separation Area ----------------------------------------------

  AreaOLD extendedDaySeparationArea(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return new AreaOLD(
      name: AreaNameOLD.extendedDaySeparationArea,
      size: extendedDaySeparationAreaSize(daySeparationNumber),
      left: extendedDaySeparationAreaLeft(daySeparationNumber),
      right: extendedDaySeparationAreaRight(daySeparationNumber),
      top: extendedDaySeparationAreaTop(daySeparationNumber),
      bottom: extendedDaySeparationAreaBottom(daySeparationNumber),
      minuteOfDayFromAreaTop: (int minuteOfDay) =>
          minuteOfDayFromTopInsideExtendedDaySeparationArea(
            daySeparationNumber,
            minuteOfDay,
          ),
      heightOfDuration: (int duration) =>
          heightOfDurationInsideExtendedDaySeparationArea(
            daySeparationNumber,
            duration,
          ),
    );
  }

  double extendedDaySeparationAreaWidth(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return dimensionsData.daySeparationAreaWidth;
  }

  double extendedDaySeparationAreaHeight(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return contentAreaHeight;
  }

  Size extendedDaySeparationAreaSize(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return new Size(
      extendedDaySeparationAreaWidth(daySeparationNumber),
      extendedDaySeparationAreaHeight(daySeparationNumber),
    );
  }

  double extendedDaySeparationAreaLeft(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return dayAreaRight(daySeparationNumber);
  }

  double extendedDaySeparationAreaRight(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    double r = 0.0;
    r = daySeparationAreaLeft(daySeparationNumber);
    r += daySeparationAreaWidth(daySeparationNumber);
    return r;
  }

  double extendedDaySeparationAreaTop(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return contentAreaTop;
  }

  double extendedDaySeparationAreaBottom(int daySeparationNumber) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return contentAreaBottom;
  }

  double minuteOfDayFromTopInsideExtendedDaySeparationArea(
    int daySeparationNumber,
    int minuteOfDay,
  ) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    double r = daySeparationAreaTop(daySeparationNumber);
    r += minuteOfDayFromTopInsideDaySeparationArea(
        daySeparationNumber, minuteOfDay);
    return r;
  }

  double heightOfDurationInsideExtendedDaySeparationArea(
    int daySeparationNumber,
    int duration,
  ) {
    _throwArgumentErrorIfInvalidDaySeparationNumber(daySeparationNumber);

    return heightOfDuration(duration);
  }

  // ---------------------------------------------------------------------------

  int get _totalNumberOfMinutes => restrictionsData.totalNumberOfMinutes;

  int get _numberOfDays => daysData.numberOfDays;

  int get _numberOfDaySeparations => _numberOfDays - 1;

  void _throwArgumentErrorIfInvalidDayNumber(int dayNumber) {
    if (dayNumber >= _numberOfDays) {
      throw new ArgumentError.value(
        dayNumber,
        "dayNumber",
        "DayNumber is greater that the ammount of days this PositioningAssistant can position ($_numberOfDays).",
      );
    }
    if (dayNumber < 0) {
      throw new ArgumentError.value(
        dayNumber,
        "dayNumber",
        "DayNumber must be greater or equal to 0.",
      );
    }
  }

  void _throwArgumentErrorIfInvalidDaySeparationNumber(
      int daySeparationNumber) {
    if (daySeparationNumber >= _numberOfDaySeparations) {
      throw new ArgumentError.value(
        daySeparationNumber,
        "daySeparationNumber",
        "There are numberOfDays -1 daySeparations (number of day separations: $_numberOfDaySeparations)",
      );
    }
    if (daySeparationNumber < 0) {
      throw new ArgumentError.value(
        daySeparationNumber,
        "daySeparationNumber",
        "DaySeparationNumber must be greater or equal to 0",
      );
    }
  }

  /// Returns number of minutes between [minimumMinuteOfDay] and [minuteOfDay].
  int _minutesFromMinimumMinute(int minuteOfDay) {
    return minuteOfDay - restrictionsData.minimumMinuteOfDay;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositioningAssistant &&
          runtimeType == other.runtimeType &&
          daysData == other.daysData &&
          dimensionsData == other.dimensionsData &&
          restrictionsData == other.restrictionsData &&
          sizeConstraintsData == other.sizeConstraintsData;

  @override
  int get hashCode =>
      daysData.hashCode ^
      dimensionsData.hashCode ^
      restrictionsData.hashCode ^
      sizeConstraintsData.hashCode;
}
