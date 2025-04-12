import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final double dotSize;
  final Color dotColor;
  final Duration animationDuration;

  const TypingIndicator({
    super.key,
    this.dotSize = 8.0,
    this.dotColor = Colors.green,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  TypingIndicatorState createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();

    // Create staggered animations for each dot
    _dotAnimations = List.generate(3, (index) {
      final start = index * 0.2; // Delay each dot
      final end = start + 0.5;
      return Tween<double>(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _dotAnimations[index].value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: widget.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
