import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../widgets/github_icon.dart';

class ProjectCard extends StatefulWidget {
  final String name;
  final String date;
  final String desc;
  final String stack;
  final String? githubUrl;
  final String? tag;

  const ProjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.desc,
    required this.stack,
    this.githubUrl,
    this.tag,
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.githubUrl != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.githubUrl != null
            ? () => _launchUrl(widget.githubUrl!)
            : null,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.name,
                            style: GruvboxText.body(
                              color: GruvboxColors.yellow,
                              size: 14,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (widget.tag != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  GruvboxColors.yellow.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color:
                                    GruvboxColors.yellow.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.tag!,
                              style: GruvboxText.body(
                                color: GruvboxColors.yellow,
                                size: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
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
      ),
    );
  }
}
