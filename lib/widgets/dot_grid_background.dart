import 'package:flutter/material.dart';
import '../../config/colors.dart';

class DotGridBackground extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final Color dotColor;

  const DotGridBackground({
    super.key,
    this.dotSize = 2.0,
    this.spacing = 24.0,
    this.dotColor = GruvboxColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DotGridPainter(
        dotSize: dotSize,
        spacing: spacing,
        dotColor: dotColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class DotGridPainter extends CustomPainter {
  final double dotSize;
  final double spacing;
  final Color dotColor;

  DotGridPainter({
    required this.dotSize,
    required this.spacing,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final radius = dotSize / 2;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotGridPainter oldDelegate) {
    return oldDelegate.dotSize != dotSize ||
        oldDelegate.spacing != spacing ||
        oldDelegate.dotColor != dotColor;
  }
}
