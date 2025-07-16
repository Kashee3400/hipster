import 'package:flutter/material.dart';

class GenericAnimatedSwitcherBox<T> extends StatelessWidget {
  final T? data;
  final Widget Function(T data) builder;
  final Duration duration;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  const GenericAnimatedSwitcherBox({
    super.key,
    required this.data,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.easeIn,
    this.switchOutCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: data != null
          ? KeyedSubtree(
              key: ValueKey(data),
              child: builder(data as T),
            )
          : const SizedBox.shrink(),
    );
  }
}
