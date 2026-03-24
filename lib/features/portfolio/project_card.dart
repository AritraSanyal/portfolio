import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../widgets/github_icon.dart';

class ProjectCard extends StatefulWidget {
  final String name;
  final String date;
  final String desc;
  final String stack;
  final String? githubUrl;

  const ProjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.desc,
    required this.stack,
    this.githubUrl,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  static final List<BoxShadow> _hoverShadows = [
    BoxShadow(
      color: GruvboxColors.overlay.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: GruvboxColors.yellow.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -4.0 : 0.0, 0.0),
        transformAlignment: Alignment.topCenter,
        padding:
            const EdgeInsets.only(top: 22, bottom: 22, left: 24, right: 24),
        decoration: BoxDecoration(
          color: GruvboxColors.bg,
          border: Border.all(
            color: _isHovered ? GruvboxColors.yellow : GruvboxColors.overlay,
            width: _isHovered ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered ? _hoverShadows : null,
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
                    widget.name,
                    style: GruvboxText.body(
                      color: GruvboxColors.yellow,
                      size: 14,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(widget.date, style: GruvboxText.surface(size: 11)),
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.desc, style: GruvboxText.description()),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.stack,
                  style: GruvboxText.body(
                    color: GruvboxColors.cyan,
                    size: 11,
                  ),
                ),
                GithubIcon(url: widget.githubUrl, size: 20),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
