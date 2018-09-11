import 'package:test/test.dart';

import 'package:calendar_views/src/_internal_date_time/all.dart';

void main() {
  group("Month", () {
    _testFactoryFromDateTime();
    _testAdd();
  });
}

void _testFactoryFromDateTime() {
  group("factory .fromDateTime", () {
    test("test 1", () {
      DateTime dateTime = new DateTime(2018, 3, 31);

      Month actual = new Month.fromDateTime(dateTime);
      Month matcher = new Month(2018, 3);

      expect(actual, matcher);
    });
  });
}

void _testAdd() {
  group(".addMonths", () {
    test("add 0", () {
      Month month = new Month(2018, 1);

      Month actual = month.addMonths(0);
      Month matcher = month;

      expect(actual, matcher);
    });

    test("add 1", () {
      Month month = new Month(2018, 1);

      Month actual = month.addMonths(1);
      Month matcher = new Month(2018, 2);

      expect(actual, matcher);
    });

    test("add 1, goes to next year", () {
      Month month = new Month(2018, 12);

      Month actual = month.addMonths(1);
      Month matcher = new Month(2019, 1);

      expect(actual, matcher);
    });

    test("add 10", () {
      Month month = new Month(2018, 2);

      Month actual = month.addMonths(10);
      Month matcher = new Month(2018, 12);

      expect(actual, matcher);
    });

    test("add 10, goes to next year", () {
      Month month = new Month(2018, 9);

      Month actual = month.addMonths(10);
      Month matcher = new Month(2019, 7);

      expect(actual, matcher);
    });

    test("add 100", () {
      Month month = new Month(2018, 3);

      Month actual = month.addMonths(100);
      Month matcher = new Month(2026, 7);

      expect(actual, matcher);
    });

    test("add -1", () {
      Month month = new Month(2018, 2);

      Month actual = month.addMonths(-1);
      Month matcher = new Month(2018, 1);

      expect(actual, matcher);
    });

    test("add -1, goes to previous year", () {
      Month month = new Month(2018, 1);

      Month actual = month.addMonths(-1);
      Month matcher = new Month(2017, 12);

      expect(actual, matcher);
    });

    test("add -10", () {
      Month month = new Month(2018, 11);

      Month actual = month.addMonths(-10);
      Month matcher = new Month(2018, 1);

      expect(actual, matcher);
    });

    test("add -10, goes to previous year", () {
      Month month = new Month(2018, 1);

      Month actual = month.addMonths(-10);
      Month matcher = new Month(2017, 3);

      expect(actual, matcher);
    });

    test("add -100", () {
      Month month = new Month(2018, 3);

      Month actual = month.addMonths(-100);
      Month matcher = new Month(2009, 11);

      expect(actual, matcher);
    });
  });
}
