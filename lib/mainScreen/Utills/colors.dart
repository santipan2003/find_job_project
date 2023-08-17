import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeDirectionColor {
  static const right = Color.fromRGBO(255, 105, 180, 1);
  static const left = Color.fromRGBO(255, 0, 0, 1);
  static const up =   Color.fromRGBO(255, 191, 0, 1);
  static const down = Color.fromRGBO(255, 191, 0, 1);
}

extension SwipeDirecionX on SwipeDirection {
  Color get color {
    switch (this) {
      case SwipeDirection.right:
        return const Color.fromRGBO(255, 105, 180, 1);
      case SwipeDirection.left:
        return const Color.fromRGBO(255, 0, 0, 1);
      case SwipeDirection.up:
        return const Color.fromRGBO(255, 191, 0, 1);
      case SwipeDirection.down:
        return const Color.fromRGBO(255, 191, 0,1);
    }
  }
}