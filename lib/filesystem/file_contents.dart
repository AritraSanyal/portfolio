import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/colors.dart';
import '../config/text_styles.dart';

// ── Helper ────────────────────────────────────────────────────────────────────

RichText _line(List<TextSpan> spans) => RichText(text: TextSpan(children: spans));
RichText _blank() => RichText(text: const TextSpan(text: ''));

TextSpan _s(String t, {Color? c, FontWeight? w}) => TextSpan(
      text: t,
      style: GruvboxText.body(color: c).copyWith(fontWeight: w),
    );

TextSpan _link(String label, String url) => TextSpan(
      text: label,
      style: GruvboxText.body(color: GruvboxColors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () => launchUrl(Uri.parse(url)),
    );

// ── about.md ─────────────────────────────────────────────────────────────────

List<Widget> buildAbout() {
  return [
    _line([_s('# About', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _line([_s('──────────────────────────────', c: GruvboxColors.surface)]),
    _line([_s(
      // TODO: Replace with your actual bio paragraph
      'A Flutter developer who turns caffeine and Dart code into polished',
      c: GruvboxColors.body,
    )]),
    _line([_s(
      'cross-platform experiences. Passionate about clean architecture,',
      c: GruvboxColors.body,
    )]),
    _line([_s(
      'smooth animations, and shipping things that actually work.',
      c: GruvboxColors.body,
    )]),
    _blank(),
    _line([_s('## Journey', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _blank(),
    _line([
      // TODO: Replace years and milestones with your actual timeline
      _s('2019', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Started programming, fell in love with mobile dev', c: GruvboxColors.body),
    ]),
    _line([
      _s('2020', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Discovered Flutter; first app shipped on Play Store', c: GruvboxColors.body),
    ]),
    _line([
      _s('2021', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Firebase, Riverpod, and real production traffic', c: GruvboxColors.body),
    ]),
    _line([
      _s('2022', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Freelance Flutter consulting, 3 client apps delivered', c: GruvboxColors.body),
    ]),
    _line([
      _s('2023', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Open-source contributions, exploring Flutter Web', c: GruvboxColors.body),
    ]),
    _line([
      _s('2024', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Built this terminal portfolio — because why not', c: GruvboxColors.body),
    ]),
    _blank(),
  ];
}

// ── skills.md ────────────────────────────────────────────────────────────────

List<Widget> buildSkills() {
  Widget bar(String skill, int filled) {
    const total = 10;
    final empty = total - filled;
    final pct = '${filled * 10}%';
    return _line([
      _s('  ${skill.padRight(12)} [', c: GruvboxColors.body),
      _s('█' * filled, c: GruvboxColors.green),
      _s('░' * empty, c: GruvboxColors.overlay),
      _s('] ', c: GruvboxColors.body),
      _s(pct, c: GruvboxColors.muted),
    ]);
  }

  return [
    _line([_s('# Skills', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _line([_s('──────────────────────────────', c: GruvboxColors.surface)]),
    _blank(),
    _line([_s('[ Flutter & Dart ]', c: GruvboxColors.orange, w: FontWeight.w700)]),
    // TODO: Adjust skill levels (0–10) to match your actual proficiency
    bar('Flutter', 9),
    bar('Dart', 9),
    bar('Flutter Web', 8),
    bar('Animations', 7),
    _blank(),
    _line([_s('[ Backend & Tools ]', c: GruvboxColors.orange, w: FontWeight.w700)]),
    bar('Firebase', 8),
    bar('REST APIs', 7),
    bar('Git', 8),
    bar('CI/CD', 6),
    _blank(),
    _line([_s('[ State Management ]', c: GruvboxColors.orange, w: FontWeight.w700)]),
    bar('Riverpod', 8),
    bar('BLoC', 7),
    bar('Provider', 8),
    bar('GetX', 5),
    _blank(),
  ];
}

// ── projects.md ──────────────────────────────────────────────────────────────

List<Widget> buildProjects() {
  Widget card({
    required String name,
    required String description,
    required String stack,
    required String githubUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line([_s('┌─────────────────────────────────────┐', c: GruvboxColors.surface)]),
        _line([
          _s('│  ', c: GruvboxColors.surface),
          _s(name.padRight(35), c: GruvboxColors.yellow, w: FontWeight.w700),
          _s('│', c: GruvboxColors.surface),
        ]),
        _line([
          _s('│  ', c: GruvboxColors.surface),
          _s(description.padRight(35), c: GruvboxColors.body),
          _s('│', c: GruvboxColors.surface),
        ]),
        _line([_s('│                                     │', c: GruvboxColors.surface)]),
        _line([
          _s('│  ', c: GruvboxColors.surface),
          _s('Stack: ', c: GruvboxColors.cyan),
          _s(stack.padRight(28), c: GruvboxColors.body),
          _s('│', c: GruvboxColors.surface),
        ]),
        _line([
          _s('│  ', c: GruvboxColors.surface),
          _s('→ ', c: GruvboxColors.surface),
          _link(githubUrl, 'https://$githubUrl'),
          _s(' ' * (34 - githubUrl.length - 2), c: GruvboxColors.body),
          _s('│', c: GruvboxColors.surface),
        ]),
        _line([_s('└─────────────────────────────────────┘', c: GruvboxColors.surface)]),
        _blank(),
      ],
    );
  }

  return [
    _line([_s('# Projects', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _line([_s('──────────────────────────────', c: GruvboxColors.surface)]),
    _blank(),
    // TODO: Replace with your actual project details
    card(
      name: 'TODO_PROJECT_ONE',
      description: 'TODO: Short project description',
      stack: 'Flutter · Firebase · Riverpod',
      githubUrl: 'github.com/TODO_GITHUB/TODO_PROJECT_ONE',
    ),
    card(
      name: 'TODO_PROJECT_TWO',
      description: 'TODO: Short project description',
      stack: 'Flutter · REST API · BLoC',
      githubUrl: 'github.com/TODO_GITHUB/TODO_PROJECT_TWO',
    ),
    card(
      name: 'TODO_PROJECT_THREE',
      description: 'TODO: Short project description',
      stack: 'Flutter Web · Dart · Firebase',
      githubUrl: 'github.com/TODO_GITHUB/TODO_PROJECT_THREE',
    ),
  ];
}

// ── contact.md ───────────────────────────────────────────────────────────────

List<Widget> buildContact() {
  return [
    _line([_s('# Contact', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _line([_s('──────────────────────────────', c: GruvboxColors.surface)]),
    _blank(),
    _line([_s('┌──────────────────────────────────────┐', c: GruvboxColors.surface)]),
    _line([_s('│            Get In Touch              │', c: GruvboxColors.surface)]),
    _line([_s('├──────────────────────────────────────┤', c: GruvboxColors.surface)]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('Email   : ', c: GruvboxColors.cyan),
      // TODO: Replace with your actual email
      _link('TODO_EMAIL@example.com', 'mailto:TODO_EMAIL@example.com'),
      _s('         │', c: GruvboxColors.surface),
    ]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('GitHub  : ', c: GruvboxColors.cyan),
      // TODO: Replace with your GitHub profile URL
      _link('github.com/TODO_GITHUB', 'https://github.com/TODO_GITHUB'),
      _s('           │', c: GruvboxColors.surface),
    ]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('Twitter : ', c: GruvboxColors.cyan),
      // TODO: Replace with your Twitter handle
      _link('@TODO_TWITTER', 'https://twitter.com/TODO_TWITTER'),
      _s('                  │', c: GruvboxColors.surface),
    ]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('LinkedIn: ', c: GruvboxColors.cyan),
      // TODO: Replace with your LinkedIn profile URL
      _link('linkedin.com/in/TODO_LINKEDIN', 'https://linkedin.com/in/TODO_LINKEDIN'),
      _s('  │', c: GruvboxColors.surface),
    ]),
    _line([_s('└──────────────────────────────────────┘', c: GruvboxColors.surface)]),
    _blank(),
    _line([_s('Open to freelance & full-time opportunities.', c: GruvboxColors.faded)]),
    _blank(),
  ];
}
