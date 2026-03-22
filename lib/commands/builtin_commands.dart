import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/colors.dart';
import '../config/text_styles.dart';
import '../filesystem/virtual_fs.dart';
import '../filesystem/file_contents.dart';
import '../filesystem/easter_eggs.dart';
import 'command_handler.dart';

RichText _simple(String text, {Color? color}) => RichText(
      text: TextSpan(
        text: text,
        style: GruvboxText.body(color: color),
      ),
    );

// ── pwd ───────────────────────────────────────────────────────────────────────

class PwdCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return [_simple('/home/visitor/portfolio')];
  }
}

// ── whoami ────────────────────────────────────────────────────────────────────

class WhoamiCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return [
      RichText(
        text: TextSpan(
          text: 'Aritra Sanyal',
          style: GruvboxText.body(color: GruvboxColors.green, size: 13),
        ),
      ),
      _simple('Flutter dev building cross-platform mobile apps with AI.',
          color: GruvboxColors.body),
      _simple('Passionate about clean UI/UX and mobile architecture.',
          color: GruvboxColors.body),
      _simple('B.Tech CSE @ UEM Jaipur | E-Cell President | Flutter Mentor.',
          color: GruvboxColors.muted),
    ];
  }
}

// ── echo ──────────────────────────────────────────────────────────────────────

class EchoCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    if (args.isEmpty) return [_simple('')];
    return [_simple(args.join(' '))];
  }
}

// ── clear ─────────────────────────────────────────────────────────────────────
// ClearCommand is handled specially in TerminalController (calls clear()),
// but we still register a no-op here so it shows in autocomplete.

class ClearCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async => [];
}

// ── ls ────────────────────────────────────────────────────────────────────────

class LsCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    final showHidden = args.contains('-la') || args.contains('-a');
    return VirtualFS.ls(showHidden: showHidden);
  }
}

// ── cat ───────────────────────────────────────────────────────────────────────

class CatCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    if (args.isEmpty) {
      return [_simple('cat: missing operand', color: GruvboxColors.red)];
    }
    final filename = args[0].toLowerCase();

    switch (filename) {
      case 'about.md':
        return buildAbout();
      case 'skills.md':
        return buildSkills();
      case 'projects.md':
        return buildProjects();
      case 'contact.md':
        return buildContact();
      case 'resume.pdf':
        return [
          _simple("Use 'open resume.pdf' to open it in your browser.",
              color: GruvboxColors.yellow)
        ];
      case '.secret':
        return buildEasterEggs()['cat .secret'] ?? [];
      default:
        if (VirtualFS.exists(filename)) {
          return [
            _simple('cat: $filename: No reader available',
                color: GruvboxColors.red)
          ];
        }
        return [
          _simple('cat: $filename: No such file or directory',
              color: GruvboxColors.red)
        ];
    }
  }
}

// ── open ──────────────────────────────────────────────────────────────────────

class OpenCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    if (args.isEmpty) {
      return [_simple('open: missing argument', color: GruvboxColors.red)];
    }
    if (args[0].toLowerCase() == 'resume.pdf') {
      const url =
          'https://drive.google.com/uc?export=download&id=1W-c-V_WlJRwpJnir8KakdPOs9ZsjaHSt';
      try {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        return [_simple('Opening resume.pdf...', color: GruvboxColors.green)];
      } catch (_) {
        return [
          _simple('open: could not open resume.pdf', color: GruvboxColors.red)
        ];
      }
    }
    return [_simple('open: ${args[0]}: no handler', color: GruvboxColors.red)];
  }
}

// ── git ───────────────────────────────────────────────────────────────────────

class GitLogCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return buildEasterEggs()['git log'] ?? [];
  }
}

// ── vim ───────────────────────────────────────────────────────────────────────

class VimCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return buildEasterEggs()['vim'] ?? [];
  }
}

// ── man ───────────────────────────────────────────────────────────────────────

class ManCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    if (args.isNotEmpty && args[0] == 'cat') {
      return buildEasterEggs()['man cat'] ?? [];
    }
    if (args.isEmpty) {
      return [
        _simple('What manual page do you want?', color: GruvboxColors.yellow)
      ];
    }
    return [
      _simple('No manual entry for ${args[0]}', color: GruvboxColors.red)
    ];
  }
}

// ── sudo ──────────────────────────────────────────────────────────────────────

class SudoCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return buildEasterEggs()['sudo'] ?? [];
  }
}

// ── cd ────────────────────────────────────────────────────────────────────────

class CdCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    if (args.isNotEmpty && args[0] == '..') {
      return buildEasterEggs()['cd ..'] ?? [];
    }
    return [_simple('cd: you are already home.', color: GruvboxColors.muted)];
  }
}

// ── help ──────────────────────────────────────────────────────────────────────

class HelpCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return buildEasterEggs()['help'] ?? [];
  }
}

// ── fastfetch ─────────────────────────────────────────────────────────────────

class FastfetchCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return [];
  }
}

// ── exit ──────────────────────────────────────────────────────────────────────

class ExitCommand implements CommandHandler {
  @override
  Future<List<Widget>> execute(List<String> args) async {
    return [];
  }
}
