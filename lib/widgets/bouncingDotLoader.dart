import 'package:flutter/material.dart';
import 'package:ejarika_app/utils/colors.dart';

class BouncingDotsLoader extends StatefulWidget {
  const BouncingDotsLoader({super.key});

  @override
  State<BouncingDotsLoader> createState() => _BouncingDotsLoaderState();
}

class _BouncingDotsLoaderState extends State<BouncingDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  final int numberOfDots = 3;
  final double bounceHeight = 10;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _dotAnimations = List.generate(numberOfDots, (index) {
      final start = (index * 0.3) % 1.0;
      final end = (start + 0.3) % 1.0;
      return TweenSequence([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: -bounceHeight),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -bounceHeight, end: 0),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start,
            end > start ? end : end + 1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _dotAnimations.map((animation) => _buildDot(animation)).toList(),
    );
  }
}