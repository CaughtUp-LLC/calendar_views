import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/src/internal_date_items/all.dart';

import '_pager_position.dart';

class MonthPagerController {
  static const _default_monthsDeltaFromInitialMonth = 1000;

  MonthPagerController.raw({
    @required DateTime initialMonth,
    @required DateTime minimumMonth,
    @required DateTime maximumMonth,
  })  : // converts DateTime to Month
        _initialMonth = new Month.fromDateTime(initialMonth),
        _minimumMonth = new Month.fromDateTime(minimumMonth),
        _maximumMonth = new Month.fromDateTime(maximumMonth) {
    // validates _minimumMonth
    if (!(_minimumMonth.isBefore(_initialMonth) ||
        _minimumMonth == _initialMonth)) {
      throw new ArgumentError(
        "MinimumMonth should be before or same month as initialMonth.",
      );
    }
    // validates _maximumMonth
    if (!(_maximumMonth.isAfter(_initialMonth) ||
        _maximumMonth == _initialMonth)) {
      throw new ArgumentError(
        "MaximumMonth should be after or same month as initialMonth.",
      );
    }

    // sets other properties
    _initialPage = Month.getDifference(_minimumMonth, _initialMonth);
    _numberOfPages = Month.getDifference(_initialMonth, _maximumMonth);
  }

  factory MonthPagerController({
    DateTime initialMonth,
    DateTime minimumMonth,
    DateTime maximumMonth,
  }) {
    initialMonth ??= new DateTime.now();

    minimumMonth ??= initialMonth
        .add(new Duration(days: -(_default_monthsDeltaFromInitialMonth * 31)));

    maximumMonth ??= initialMonth
        .add(new Duration(days: (_default_monthsDeltaFromInitialMonth * 31)));

    return new MonthPagerController.raw(
      initialMonth: initialMonth,
      minimumMonth: minimumMonth,
      maximumMonth: maximumMonth,
    );
  }

  final Month _initialMonth;

  final Month _minimumMonth;

  final Month _maximumMonth;

  int _initialPage;

  int _numberOfPages;

  PagerPosition _pagerPosition;

  DateTime get initialMonth => _initialMonth.toDateTime();

  DateTime get minimumMonth => _minimumMonth.toDateTime();

  DateTime get maximumMonth => _maximumMonth.toDateTime();

  int get initialPage => _initialPage;

  int get numberOfPages => _numberOfPages;

  int pageOf(DateTime month) {
    Month m = new Month.fromDateTime(month);

    if (m.isBefore(_minimumMonth)) {
      return 0;
    }
    if (m.isAfter(_maximumMonth)) {
      return numberOfPages - 1;
    }
    return Month.getDifference(_minimumMonth, m);
  }

  DateTime monthOf(int page) {
    int deltaFromInitialPage = page - initialPage;

    Month month = _initialMonth.add(deltaFromInitialPage);
    return month.toDateTime();
  }

  DateTime get displayedDays {
    if (_pagerPosition == null) {
      return null;
    } else {
      return monthOf(_pagerPosition.getDisplayedPage());
    }
  }

  void attach(PagerPosition pagerPosition) {
    _pagerPosition = pagerPosition;
  }

  void detach() {
    _pagerPosition = null;
  }

  void jumpTo(DateTime week) {
    if (_pagerPosition == null) {
      print("Error: no WeekPager attached");
      return;
    }

    _pagerPosition.jumpToPage(
      pageOf(week),
    );
  }

  void animateTo(
    DateTime week, {
    @required Duration duration,
    @required Curve curve,
  }) {
    if (_pagerPosition == null) {
      print("Error: no WeekPager attached");
      return;
    }

    _pagerPosition.animateToPage(
      pageOf(week),
      duration: duration,
      curve: curve,
    );
  }
}
