import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../../../Utills/colors.dart';

class BottomButtonsRow extends StatelessWidget {
  const BottomButtonsRow({
    required this.onRewindTap,
    required this.onSwipe,
    required this.canRewind,
    super.key,
  });

  final bool canRewind;
  final VoidCallback onRewindTap;
  final ValueChanged<SwipeDirection> onSwipe;

  static const double height = 100;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomButton(
                color: Colors.white ,
                onPressed: canRewind ? onRewindTap : null,
                child: const Icon(Icons.swap_vert,size: 35,),
              ),
              _BottomButton(
                color: Colors.white,
                child: const Icon(Icons.close,color: Colors.red,),
                onPressed: () {
                  onSwipe(SwipeDirection.left);
                },
              ),
              _BottomButton(
                color: Colors.white,
                onPressed: () {
                  onSwipe(SwipeDirection.right);
                },
                child: const Icon(Icons.favorite,color: Colors.pinkAccent,),
              ),
              _BottomButton(
                color: Colors.white ,
                onPressed: () {
                  onSwipe(SwipeDirection.up);
                },
                child: const Icon(Icons.switch_access_shortcut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.onPressed,
    required this.child,
    required this.color,
  });

  final VoidCallback? onPressed;
  final Icon child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
                (states) => color,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}