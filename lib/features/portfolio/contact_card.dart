import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';

class ContactCard extends StatelessWidget {
  final String label;
  final String value;
  final String? url;

  const ContactCard({
    super.key,
    required this.label,
    required this.value,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: url != null ? () => _launchUrl(url!) : null,
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 18, right: 18),
        decoration: BoxDecoration(
          color: GruvboxColors.bg,
          border: Border.all(color: GruvboxColors.overlay),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: GruvboxText.infoLabel()),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: url != null
                  ? GruvboxText.link(size: 12)
                  : GruvboxText.infoValue(size: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
