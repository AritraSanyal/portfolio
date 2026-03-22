import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/text_styles.dart';

RichText _r(String t, Color c) => RichText(
      text: TextSpan(text: t, style: GruvboxText.body(color: c)),
    );

Map<String, List<Widget>> buildEasterEggs() {
  return {
    'cd ..': [
      _r("permission denied: you can't leave :)", GruvboxColors.red),
    ],
    'sudo rm -rf /': [
      _r('nice try.', GruvboxColors.red),
    ],
    'sudo': [
      _r('visitor is not in the sudoers file.', GruvboxColors.red),
      _r('This incident will be reported.', GruvboxColors.red),
    ],
    'cat readme.md': [
      _r('cat: README.md: No such file or directory', GruvboxColors.red),
    ],
    'cat .secret': [
      // TODO: Replace with your own fun secret message
      _r('✦ you found the secret ✦', GruvboxColors.purple),
      _r('', GruvboxColors.purple),
      _r('real talk: I spent 3 days perfecting this loading bar.',
          GruvboxColors.purple),
      _r("it's 47 lines of dart. totally worth it.", GruvboxColors.purple),
      _r('', GruvboxColors.purple),
      _r('— Aritra Sanyal', GruvboxColors.purple),
    ],
    'vim': [
      _r('opens vim... just kidding.', GruvboxColors.yellow),
      _r('(use cat instead)', GruvboxColors.yellow),
    ],
    'git log': [
      // TODO: Replace commit messages with your own fun git history
      _r('commit a1b2c3d — initial commit: existed', GruvboxColors.green),
      _r('commit f4e5d6c — feat: learned Flutter', GruvboxColors.body),
      _r('commit 9g8h7i6 — fix: life choices', GruvboxColors.body),
      _r('commit 0j1k2l3 — chore: shipped stuff', GruvboxColors.body),
    ],
    'man cat': [
      _r('CAT(1)          Portfolio Manual          CAT(1)',
          GruvboxColors.yellow),
      _r('', GruvboxColors.body),
      _r('NAME', GruvboxColors.cyan),
      _r('     cat — concatenate and display files', GruvboxColors.body),
      _r('', GruvboxColors.body),
      _r('SYNOPSIS', GruvboxColors.cyan),
      _r('     cat [file]', GruvboxColors.body),
      _r('', GruvboxColors.body),
      _r('FILES', GruvboxColors.cyan),
      _r('     about.md  skills.md  projects.md', GruvboxColors.body),
      _r('     contact.md  resume.pdf', GruvboxColors.body),
      _r('', GruvboxColors.body),
      // TODO: Replace with your name
      _r('AUTHOR', GruvboxColors.cyan),
      _r('     Aritra Sanyal', GruvboxColors.body),
      _r('', GruvboxColors.body),
      _r('BUGS', GruvboxColors.cyan),
      _r('     None. I write perfect code.', GruvboxColors.body),
    ],
    'help': [
      _r('Available commands:', GruvboxColors.yellow),
      _r('', GruvboxColors.body),
      _r('  ls              list files', GruvboxColors.body),
      _r('  ls -la          list all files (including hidden)',
          GruvboxColors.body),
      _r('  cat <file>      display file contents', GruvboxColors.body),
      _r('  open resume.pdf open resume in browser', GruvboxColors.body),
      _r('  pwd             print working directory', GruvboxColors.body),
      _r('  whoami          who are you talking to', GruvboxColors.body),
      _r('  echo <text>     print text', GruvboxColors.body),
      _r('  clear           clear the terminal', GruvboxColors.body),
      _r('  git log         interesting history', GruvboxColors.body),
      _r('  vim             definitely opens vim', GruvboxColors.body),
      _r('  man cat         the fine manual', GruvboxColors.body),
    ],
  };
}
