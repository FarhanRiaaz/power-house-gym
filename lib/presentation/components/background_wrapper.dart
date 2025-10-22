import 'package:finger_print_flutter/presentation/components/animated_overlay.dart';
import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/login_bg.png',
          fit: BoxFit.cover,
        ),
    const AnimatedOverlay(),
            child,
      ],
    );
  }
}
