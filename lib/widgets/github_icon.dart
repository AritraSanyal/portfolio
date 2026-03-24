import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/colors.dart';

class GithubIcon extends StatelessWidget {
  final String? url;
  final double size;

  const GithubIcon({
    super.key,
    this.url,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _launchUrl(url!),
      child: CustomPaint(
        size: Size(size, size),
        painter: _GithubPainter(color: GruvboxColors.yellow),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _GithubPainter extends CustomPainter {
  final Color color;

  _GithubPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.35, h * 0.0);
    path.cubicTo(
      w * 0.15,
      h * 0.0,
      w * 0.0,
      h * 0.15,
      w * 0.0,
      h * 0.35,
    );
    path.cubicTo(
      w * 0.0,
      h * 0.48,
      w * 0.08,
      h * 0.58,
      w * 0.15,
      h * 0.58,
    );
    path.cubicTo(
      w * 0.19,
      h * 0.58,
      w * 0.25,
      h * 0.52,
      w * 0.25,
      h * 0.42,
    );
    path.cubicTo(
      w * 0.25,
      h * 0.25,
      w * 0.35,
      h * 0.25,
      w * 0.35,
      h * 0.25,
    );
    path.cubicTo(
      w * 0.35,
      h * 0.25,
      w * 0.45,
      h * 0.25,
      w * 0.45,
      h * 0.42,
    );
    path.cubicTo(
      w * 0.45,
      h * 0.52,
      w * 0.51,
      h * 0.58,
      w * 0.55,
      h * 0.58,
    );
    path.cubicTo(
      w * 0.62,
      h * 0.58,
      w * 0.7,
      h * 0.48,
      w * 0.7,
      h * 0.35,
    );
    path.cubicTo(
      w * 0.7,
      h * 0.15,
      w * 0.55,
      h * 0.0,
      w * 0.35,
      h * 0.0,
    );
    path.close();

    path.moveTo(w * 0.5, h * 0.65);
    path.cubicTo(
      w * 0.45,
      h * 0.55,
      w * 0.35,
      h * 0.55,
      w * 0.3,
      h * 0.65,
    );
    path.cubicTo(
      w * 0.25,
      h * 0.75,
      w * 0.3,
      h * 0.85,
      w * 0.42,
      h * 0.95,
    );
    path.cubicTo(
      w * 0.58,
      h * 1.05,
      w * 0.7,
      h * 0.95,
      w * 0.75,
      h * 0.85,
    );
    path.cubicTo(
      w * 0.8,
      h * 0.75,
      w * 0.75,
      h * 0.65,
      w * 0.7,
      h * 0.65,
    );
    path.cubicTo(
      w * 0.65,
      h * 0.65,
      w * 0.63,
      h * 0.75,
      w * 0.58,
      h * 0.82,
    );
    path.cubicTo(
      w * 0.55,
      h * 0.88,
      w * 0.52,
      h * 0.82,
      w * 0.5,
      h * 0.72,
    );
    path.cubicTo(
      w * 0.48,
      h * 0.82,
      w * 0.45,
      h * 0.88,
      w * 0.42,
      h * 0.82,
    );
    path.cubicTo(
      w * 0.37,
      h * 0.75,
      w * 0.35,
      h * 0.65,
      w * 0.5,
      h * 0.65,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
