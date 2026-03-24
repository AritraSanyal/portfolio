import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubIcon extends StatelessWidget {
  final String? url;
  final double size;

  const GithubIcon({
    super.key,
    this.url,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _launchUrl(url!),
      child: SvgPicture.asset(
        'assets/github-svgrepo-com.svg',
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
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
