import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/src/_calendar_page_view/all.dart';
import 'package:calendar_views/src/_internal_date_items/all.dart';

import 'month_page_view.dart';

/// Controller for a [MonthPageView].
class MonthPageController extends CalendarPageController<DateTime> {
  static const default_monthsDeltaFromInitialMonth = 1000;

  MonthPageController._internal({
    @required Month initialMonth,
    @required Month minimumMonth,
    @required Month maximumMonth,
  })  : _initialMonth = initialMonth,
        _minimumMonth = minimumMonth,
        _maximumMonth = maximumMonth,
        super(
          initialPage: minimumMonth.differenceInMonthsTo(initialMonth),
          numberOfPages: minimumMonth.differenceInMonthsTo(maximumMonth) + 1,
        );

  /// Creates the controller.
  ///
  /// If [initialMonth] is set to null,
  /// today-month will be set as initial month.
  ///
  /// If [minimumMonth] is set to null,
  /// a month [default_monthsDeltaFromInitialMonth] before [initialMonth] will be set as [minimumMonth].
  ///
  ///
  /// If [maximumMonth] is set to null,
  /// a mont [default_monthsDeltaFromInitialMonth] after [initialMonth] will be set as [maximumMonth].
  factory MonthPageController({
    DateTime initialMonth,
    DateTime minimumMonth,
    DateTime maximumMonth,
  }) {
    // Converts to internal representation of months
    Month initial;
    Month minimum;
    Month maximum;

    if (initialMonth != null) {
      initial = new Month.fromDateTime(initialMonth);
    } else {
      initial = new Month.now();
    }

    if (minimumMonth != null) {
      minimum = new Month.fromDateTime(minimumMonth);
    } else {
      minimum = initial.add(-default_monthsDeltaFromInitialMonth);
    }

    if (maximumMonth != null) {
      maximum = new Month.fromDateTime(maximumMonth);
    } else {
      maximum = initial.add(default_monthsDeltaFromInitialMonth);
    }

    // validates
    if (!(minimum.isBefore(initial)) || minimum == initial) {
      throw new ArgumentError(
        "minimumMonth should be before or same month as initialMonth",
      );
    }
    if (!(maximum.isAfter(initial) || maximum == initial)) {
      throw new ArgumentError(
        "maximumMonth should be before or same month as initialMonth",
      );
    }

    return new MonthPageController._internal(
      initialMonth: initial,
      minimumMonth: minimum,
      maximumMonth: maximum,
    );
  }

  final Month _initialMonth;
  final Month _minimumMonth;
  final Month _maximumMonth;

  /// Month shown when first creating the controlled [MonthPageView].
  DateTime get initialMonth => _initialMonth.toDateTime();

  /// Minimum month shown in the controlled [MonthPageView] (inclusive).
  DateTime get minimumMonth => _minimumMonth.toDateTime();

  /// Maximum month shown in the controlled [MonthPageView] (inclusive).
  DateTime get maximumMonth => _maximumMonth.toDateTime();

  @override
  DateTime representationOfCurrentPage() {
    return displayedMonth();
  }

  @override
  int indexOfPageThatRepresents(DateTime pageRepresentation) {
    return pageOf(pageRepresentation);
  }

  /// Returns index of page that displays [month].
  ///
  /// If [month] is before [minimumMonth], index of first page is returned.
  ///
  /// If [month] is after [maximumMonth], index of last page is returned.
  int pageOf(DateTime month) {
    Month m = new Month.fromDateTime(month);

    if (m.isBefore(_minimumMonth)) {
      return 0;
    }
    if (m.isAfter(_maximumMonth)) {
      return numberOfPages - 1;
    }
    return _minimumMonth.differenceInMonthsTo(m);
  }

  /// Returns month displayed on [page].
  ///
  /// Values of returned month except year and month are set to their default values.
  DateTime monthOf(int page) {
    int deltaFromInitialPage = page - initialPage;

    Month month = _initialMonth.add(deltaFromInitialPage);
    return month.toDateTime();
  }

  /// Returns currently displayed month in the controlled [MonthPageView].
  ///
  /// If no [MonthPageView] is attached it returns null.
  DateTime displayedMonth() {
    int displayedPage = super.displayedPage();

    if (displayedPage == null) {
      return null;
    } else {
      return monthOf(displayedPage);
    }
  }

  /// Changes which [month] is displayed in the controlled [MonthPageView].
  ///
  /// If no [MonthPageView] is attached it does nothing.
  void jumpToMonth(DateTime month) {
    int pageOfMonth = pageOf(month);

    super.jumpToPage(pageOfMonth);
  }

  /// Animates the controlled [MonthPageView] to the given [month].
  ///
  /// If no [MonthPageView] is attached it does nothing.
  Future<Null> animateTo(
    DateTime month, {
    @required Duration duration,
    @required Curve curve,
  }) {
    int pageOfMonth = pageOf(month);

    return super.animateToPage(
      pageOfMonth,
      duration: duration,
      curve: curve,
    );
  }
}
