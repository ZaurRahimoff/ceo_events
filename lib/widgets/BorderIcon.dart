import 'package:ceo_events/widgets/theme.dart';
import 'package:flutter/material.dart';


class BorderIcon extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width, height;

  const BorderIcon(
      {Key key,
      @required this.child,
      this.padding,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: COLOR_WHITE,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(color: COLOR_GREY.withAlpha(40), width: 2)),
        padding: padding ?? const EdgeInsets.all(5.0),
        child: Center(child: child));
  }
}