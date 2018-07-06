import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/src/_calendar_page_view/all.dart';

import 'month_page_builder.dart';
import 'month_page_controller.dart';

/// Custom pageView in which each page represents a month.
class MonthPageView extends CalendarPageView {
  MonthPageView._internal({
    @required this.controller,
    @required this.pageBuilder,
    @required this.onMonthChanged,
    @required Axis scrollDirection,
    @required bool reverse,
    @required ScrollPhysics physics,
    @required bool pageSnapping,
  })  : assert(controller != null),
        assert(pageBuilder != null),
        super(
          scrollDirection: scrollDirection,
          reverse: reverse,
          physics: physics,
          pageSnapping: pageSnapping,
        );

  /// Creates pageView with each page representing a month.
  factory MonthPageView({
    MonthPageController controller,
    @required MonthPageBuilder pageBuilder,
    ValueChanged<DateTime> onMonthChanged,
    Axis scrollDirection = Axis.horizontal,
    bool reverse = false,
    ScrollPhysics scrollPhysics,
    bool pageSnapping = true,
  }) {
    controller ??= new MonthPageController();

    return new MonthPageView._internal(
      controller: controller,
      pageBuilder: pageBuilder,
      onMonthChanged: onMonthChanged,
      scrollDirection: scrollDirection,
      reverse: reverse,
      physics: scrollPhysics,
      pageSnapping: pageSnapping,
    );
  }

  /// Object in charge of controlling this [MonthPageView].
  final MonthPageController controller;

  /// Function that builds a page.
  final MonthPageBuilder pageBuilder;

  /// Called whenever displayed month in this [MonthPageView] changes.
  final ValueChanged<DateTime> onMonthChanged;

  @override
  _MonthPageViewState createState() => new _MonthPageViewState();
}

class _MonthPageViewState extends CalendarPageViewState<MonthPageView> {
  @override
  bool hasAnythingChanged(MonthPageView oldWidget) {
    return widget.controller != oldWidget.controller ||
        widget.pageBuilder != oldWidget.pageBuilder ||
        widget.onMonthChanged != oldWidget.onMonthChanged;
  }

  @override
  void onPageChanged(int page) {
    if (widget.onMonthChanged != null) {
      DateTime month = widget.controller.monthOf(page);

      widget.onMonthChanged(month);
    }
  }

  @override
  Widget pageBuilder(BuildContext context, int page) {
    DateTime month = widget.controller.monthOf(page);

    return widget.pageBuilder(context, month);
  }
}
