import 'package:flutter/widgets.dart';

class CustomPageScrollPhysics extends ScrollPhysics {
  final bool allowScroll;

  const CustomPageScrollPhysics({ required ScrollPhysics parent, required this.allowScroll})
      : super(parent: parent);

  @override
  ScrollPhysics build(ScrollPhysics ancestor) {
    return CustomPageScrollPhysics(parent: parent!.applyTo(ancestor), allowScroll: allowScroll);
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return allowScroll;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (!allowScroll) {
      // Prevent any scrolling if allowScroll is false
      return null;
    }
    return super.createBallisticSimulation(position, velocity);
  }
}