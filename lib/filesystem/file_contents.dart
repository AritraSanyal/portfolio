import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/colors.dart';
import '../config/text_styles.dart';

// ── Helper ────────────────────────────────────────────────────────────────────

RichText _line(List<TextSpan> spans) =>
    RichText(text: TextSpan(children: spans));
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
    _blank(),
    _line([
      _s(
        'Flutter developer building cross-platform mobile apps with AI.',
        c: GruvboxColors.body,
      )
    ]),
    _line([
      _s(
        'Passionate about clean UI/UX and mobile app architecture.',
        c: GruvboxColors.body,
      )
    ]),
    _line([
      _s(
        'Currently pursuing B.Tech in CSE @ UEM Jaipur.',
        c: GruvboxColors.body,
      )
    ]),
    _blank(),
    _line([
      _s('## Roles & Activities', c: GruvboxColors.yellow, w: FontWeight.w700)
    ]),
    _blank(),
    _line([
      _s('President', c: GruvboxColors.orange, w: FontWeight.w600),
      _s(' — E-Cell, UEM Jaipur', c: GruvboxColors.muted),
    ]),
    _line([
      _s('Leading a 30-member team, executing flagship events.',
          c: GruvboxColors.body)
    ]),
    _line([
      _s('Secured sponsorships, increased revenue by ~45% YoY.',
          c: GruvboxColors.body)
    ]),
    _blank(),
    _line([
      _s('Flutter Mentor', c: GruvboxColors.orange, w: FontWeight.w600),
      _s(' — Workshop Facilitator', c: GruvboxColors.muted),
    ]),
    _line([
      _s('Mentored 100+ students in Flutter & Dart basics.',
          c: GruvboxColors.body)
    ]),
    _line([
      _s('Guided participants from zero to their first cross-platform app.',
          c: GruvboxColors.body)
    ]),
    _blank(),
    _line([_s('## Journey', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _blank(),
    _line([
      _s('2022', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Started B.Tech CSE, discovered Flutter', c: GruvboxColors.body),
    ]),
    _line([
      _s('2024', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Built AI-powered Advertisement Generation App',
          c: GruvboxColors.body),
    ]),
    _line([
      _s('2025', c: GruvboxColors.orange),
      _s(' ──► ', c: GruvboxColors.surface),
      _s('Shipped Mesure health app, became E-Cell President',
          c: GruvboxColors.body),
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
    _line([
      _s('[ Mobile Development ]', c: GruvboxColors.orange, w: FontWeight.w700)
    ]),
    bar('Flutter', 9),
    bar('Dart', 9),
    bar('Android', 7),
    bar('iOS', 6),
    bar('Firebase', 8),
    _blank(),
    _line([_s('[ Languages ]', c: GruvboxColors.orange, w: FontWeight.w700)]),
    bar('Python', 7),
    bar('Java', 7),
    bar('C', 6),
    bar('Kotlin', 5),
    _blank(),
    _line([
      _s('[ Tools & Concepts ]', c: GruvboxColors.orange, w: FontWeight.w700)
    ]),
    bar('Git/GitHub', 9),
    bar('REST APIs', 8),
    bar('UI/UX', 8),
    bar('Animations', 7),
    bar('CI/CD', 6),
    _blank(),
    _line([_s('[ AI/ML ]', c: GruvboxColors.orange, w: FontWeight.w700)]),
    bar('PyTorch', 6),
    bar('LLMs', 5),
    bar('Hugging Face', 6),
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
        _line([
          _s('┌─────────────────────────────────────┐',
              c: GruvboxColors.surface)
        ]),
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
        _line([
          _s('│                                     │',
              c: GruvboxColors.surface)
        ]),
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
        _line([
          _s('└─────────────────────────────────────┘',
              c: GruvboxColors.surface)
        ]),
        _blank(),
      ],
    );
  }

  return [
    _line([_s('# Projects', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _line([_s('──────────────────────────────', c: GruvboxColors.surface)]),
    _blank(),
    card(
      name: 'Advertisement Generation App',
      description: 'AI-powered ad copy generator',
      stack: 'Flutter · Gemini API · Firebase',
      githubUrl: 'github.com/AritraSanyal/TODO_AD_PROJECT',
    ),
    card(
      name: 'Mesure — Health App',
      description: 'Camera-based health monitoring',
      stack: 'Flutter · Firebase · Signal Proc.',
      githubUrl: 'github.com/AritraSanyal/TODO_MESURE_PROJECT',
    ),
  ];
}

// ── contact.md ───────────────────────────────────────────────────────────────

List<Widget> buildContact() {
  return [
    _line([_s('# Contact', c: GruvboxColors.yellow, w: FontWeight.w700)]),
    _line([_s('──────────────────────────────', c: GruvboxColors.surface)]),
    _blank(),
    _line([
      _s('┌──────────────────────────────────────┐', c: GruvboxColors.surface)
    ]),
    _line([
      _s('│            Get In Touch              │', c: GruvboxColors.surface)
    ]),
    _line([
      _s('├──────────────────────────────────────┤', c: GruvboxColors.surface)
    ]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('Email   : ', c: GruvboxColors.cyan),
      _link('aritra.sanyal.official@gmail.com',
          'mailto:aritra.sanyal.official@gmail.com'),
      _s('  │', c: GruvboxColors.surface),
    ]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('GitHub  : ', c: GruvboxColors.cyan),
      _link('github.com/AritraSanyal', 'https://github.com/AritraSanyal'),
      _s('        │', c: GruvboxColors.surface),
    ]),
    _line([
      _s('│  ', c: GruvboxColors.surface),
      _s('Phone   : ', c: GruvboxColors.cyan),
      _s('+91 7980769212', c: GruvboxColors.body),
      _s('                │', c: GruvboxColors.surface),
    ]),
    _line([
      _s('└──────────────────────────────────────┘', c: GruvboxColors.surface)
    ]),
    _blank(),
    _line([
      _s('Open to freelance & full-time opportunities.', c: GruvboxColors.faded)
    ]),
    _blank(),
  ];
}
