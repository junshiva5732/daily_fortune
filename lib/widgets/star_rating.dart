import 'package:flutter/material.dart';

/// 1~5점을 별로 표시.
class StarRating extends StatelessWidget {
  final int score;
  final double size;
  final Color? color;

  const StarRating({super.key, required this.score, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.amber;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < score ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < score ? c : c.withValues(alpha: 0.35),
        );
      }),
    );
  }
}
