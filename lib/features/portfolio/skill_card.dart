import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';

class SkillCard extends StatelessWidget {
  final String name;
  final int percent;
  final Color color;

  const SkillCard({
    super.key,
    required this.name,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GruvboxColors.bg,
        border: Border.all(color: GruvboxColors.overlay),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GruvboxText.body(color: GruvboxColors.cyan, size: 11),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(1.5),
            child: SizedBox(
              height: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        color: GruvboxColors.overlay,
                      ),
                      FractionallySizedBox(
                        widthFactor: percent / 100,
                        child: Container(color: color),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$percent%',
            style: GruvboxText.muted(size: 9),
          ),
        ],
      ),
    );
  }
}
