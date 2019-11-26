import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class CustomPanGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function onVerticalScroll;

  CustomPanGestureRecognizer({@required this.onVerticalScroll});

  @override
  String get debugDescription => "customSlide";

  @override
  void didStopTrackingLastPointer(int pointer) { }

  @override
  void handleEvent(PointerEvent event) {
    //if(event.)
    //event.
    //if the event is a pointer and goes up or down, win
  }

}