import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/src/_internal_date_time/all.dart';
import 'package:calendar_views/src/calendar_page_view/all.dart';

import '_page_month.dart';
import 'month_page_builder.dart';
import 'month_page_controller.dart';
import 'month_page_link.dart';

/// Widget similar to [PageView] but instead of page-number it gives each page a month.
///
/// The number of months that can be displayed is virtually infinite.
class MonthPageView extends CalendarPageView {
  MonthPageView({
    Axis scrollDirection = CalendarPageView.default_scroll_direction,
    bool pageSnapping = CalendarPageView.default_page_snapping,
    bool reverse = CalendarPageView.default_reverse,
    ScrollPhysics physics = CalendarPageView.default_physics,
    MonthPageController controller,
    @required this.pageBuilder,
    this.onMonthChanged,
  })  : this.controller = controller ?? new MonthPageController(),
        assert(controller != null),
        assert(pageBuilder != null),
        super(
          scrollDirection: scrollDirection,
          pageSnapping: pageSnapping,
          reverse: reverse,
          physics: physics,
        );

  /// Object for controlling this widget.
  final MonthPageController controller;

  /// Function that builds a page.
  final MonthPageBuilder pageBuilder;

  /// Called whenever the displayed month changes.
  ///
  /// Properties of DateTime except for year and month are set to their default values.
  final ValueChanged<DateTime> onMonthChanged;

  @override
  CalendarPageViewState createState() => new _MonthPageViewState();
}

class _MonthPageViewState extends CalendarPageViewState<MonthPageView, Month> {
  PageMonth _pageMonth;

  @override
  void initState() {
    super.initState();

    Month initialMonth = new Month.fromDateTime(widget.controller.initialMonth);
    _pageMonth = new PageMonth(
      initialPage: CalendarPageViewState.initial_page,
      initialMonth: initialMonth,
    );

    _attachToController();
  }

  @override
  void didUpdateWidget(MonthPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.detach();
      _attachToController();
    }
  }

  void _attachToController() {
    widget.controller.attach(
      _createMonthPageLink(),
    );
  }

  MonthPageLink _createMonthPageLink() {
    return new MonthPageLink(
      currentMonth: _getCurrentMonth,
      jumpToMonth: _jumpToMonth,
      animateToMonth: _animateToMonth,
      currentPage: getCurrentPage,
      jumpToPage: jumpToPage,
      animateToPage: animateToPage,
    );
  }

  DateTime _getCurrentMonth() {
    int currentPage = getCurrentPage();
    Month currentMonth = getRepresentationOfPage(currentPage);

    return currentMonth.toDateTime();
  }

  void _jumpToMonth(DateTime month) {
    Month m = new Month.fromDateTime(month);
    int page = getPageOfRepresentation(m);

    jumpToPage(page);
  }

  Future<Null> _animateToMonth(
    DateTime month, {
    @required Duration duration,
    @required Curve curve,
  }) {
    Month m = new Month.fromDateTime(month);
    int page = getPageOfRepresentation(m);

    return animateToPage(
      page,
      duration: duration,
      curve: curve,
    );
  }

  @override
  Month getRepresentationOfPage(int page) {
    return _pageMonth.monthOfPage(page);
  }

  @override
  int getPageOfRepresentation(Month representation) {
    return _pageMonth.pageOfMonth(representation);
  }

  @override
  onRepresentationChanged(Month representation) {
    if (widget.onMonthChanged != null) {
      DateTime month = representation.toDateTime();
      widget.onMonthChanged(month);
    }
  }

  @override
  Widget itemBuilder(BuildContext context, Month representation) {
    DateTime month = representation.toDateTime();

    return widget.pageBuilder(context, month);
  }
}
