import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';

class ProjectCard extends StatelessWidget {
  final String name;
  final String date;
  final String desc;
  final String stack;

  const ProjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.desc,
    required this.stack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 22, bottom: 22, left: 24, right: 24),
      decoration: BoxDecoration(
        color: GruvboxColors.bg,
        border: Border.all(color: GruvboxColors.overlay),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GruvboxText.body(color: GruvboxColors.yellow, size: 14)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(date, style: GruvboxText.surface(size: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Text(desc, style: GruvboxText.description()),
          const SizedBox(height: 10),
          Text(stack,
              style: GruvboxText.body(color: GruvboxColors.cyan, size: 11)),
        ],
      ),
    );
  }
}
