import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../position.dart';

Positioned supportLineItemBuilder({
  @required BuildContext context,
  @required Position position,
  @required double width,
  @required int minuteOfDay,
}) {
  return new Positioned(
    top: position.top,
    left: position.left,
    width: width,
    child: new SupportLineItem(),
  );
}

class SupportLineItem extends StatelessWidget {
  const SupportLineItem({
    this.height = 0.5,
    this.color = Colors.black,
  })  : assert(height != null),
        assert(color != null);

  /// Height of the support line.
  final double height;

  /// Color of the support line.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints.expand(height: height),
      color: color,
    );
  }
}
