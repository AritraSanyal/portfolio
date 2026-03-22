import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';

class PortfolioSection extends StatelessWidget {
  final String tag;
  final Widget child;
  final bool showDivider;

  const PortfolioSection({
    super.key,
    required this.tag,
    required this.child,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GruvboxColors.bgHard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDivider)
            const Divider(height: 1, color: GruvboxColors.overlay),
          Padding(
            padding: _responsivePadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tag, style: GruvboxText.tag()),
                    const SizedBox(height: 12),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final t = ((width - 320) / (1200 - 320)).clamp(0.0, 1.0);
    final vertical = lerpDouble(36, 64, t)!;
    final horizontal = lerpDouble(20, 60, t)!;
    return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
  }
}
