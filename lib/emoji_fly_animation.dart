import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmojiFlyAnimation extends StatefulWidget {
  String assetUrl;
  final VoidCallback endedCallback;
  final Offset? position;

  EmojiFlyAnimation({required this.assetUrl, required this.endedCallback, this.position});

  @override
  State<EmojiFlyAnimation> createState() => _EmojiFlyAnimationState();
}

class _EmojiFlyAnimationState extends State<EmojiFlyAnimation> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? positionAnimation;
  Animation<double>? opacityAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..addStatusListener((status) {
      if (status == AnimationStatus.completed)
        if (mounted) {
          widget.endedCallback();
        }
    });
    positionAnimation = Tween<Offset>(begin: widget.position ?? Offset(200, 200), end: Offset(200, 100)).animate(controller!);
    opacityAnimation = Tween<double>(begin: 1, end: 0).animate(controller!);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller?.forward();
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, child) {
        return Transform.translate(
          offset: positionAnimation?.value??Offset(0, 0),
          child: Opacity(
            opacity: opacityAnimation?.value ?? 1,
            child: Image.asset(
          widget.assetUrl,
          width: 50,
          height: 50,
            ),
          ),
        );
      }
    );
  }
}
