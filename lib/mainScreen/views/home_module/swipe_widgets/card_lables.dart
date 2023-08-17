import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../Utills/colors.dart';

const _labelAngle = math.pi / 2 * 0.2;

class CardLabel extends StatelessWidget {
  const CardLabel._({
    required this.color,
    required this.label,
    required this.angle,
    required this.alignment,
  });

  factory CardLabel.right() {
    return const CardLabel._(
      color: SwipeDirectionColor.right,
      label: Icons.favorite,
      angle: -_labelAngle,
      alignment: Alignment.center,
    );
  }

  factory CardLabel.left() {
    return const CardLabel._(
      color: SwipeDirectionColor.left,
      label: Icons.close,
      angle: _labelAngle,
      alignment: Alignment.center,
    );
  }

  factory CardLabel.up() {
    return const CardLabel._(
      color: SwipeDirectionColor.up,
      label: Icons.switch_access_shortcut,
      angle: _labelAngle,
      alignment: Alignment(0, 0.5),
    );
  }

  factory CardLabel.down() {
    return const CardLabel._(
      color: SwipeDirectionColor.down,
      label: Icons.switch_access_shortcut,
      angle: -_labelAngle,
      alignment: Alignment(0, -0.75),
    );
  }

  final Color color;
  final IconData label;
  final double angle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: color.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 30,
      ),
      child: Transform.rotate(
        angle: angle,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 4,
            ),
            color: Colors.white,
            shape: BoxShape.circle,
           // borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(6),
          child:  Icon(label)/*Text(
            label,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: color,
              height: 1,
            ),
          ),*/
        ),
      ),
    );
  }
}