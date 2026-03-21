import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/text_styles.dart';

enum FileType { markdown, pdf, hidden }

class VirtualFile {
  final String name;
  final FileType type;

  const VirtualFile(this.name, this.type);
}

class VirtualFS {
  VirtualFS._();

  static final Map<String, VirtualFile> _files = {
    'about.md':    const VirtualFile('about.md',    FileType.markdown),
    'skills.md':   const VirtualFile('skills.md',   FileType.markdown),
    'projects.md': const VirtualFile('projects.md', FileType.markdown),
    'contact.md':  const VirtualFile('contact.md',  FileType.markdown),
    'resume.pdf':  const VirtualFile('resume.pdf',  FileType.pdf),
    '.secret':     const VirtualFile('.secret',     FileType.hidden),
  };

  static List<Widget> ls({bool showHidden = false}) {
    final visible = _files.values.where((f) {
      if (f.type == FileType.hidden) return showHidden;
      return true;
    }).toList();

    final spans = <TextSpan>[];
    for (final f in visible) {
      Color color;
      switch (f.type) {
        case FileType.markdown:
          color = GruvboxColors.cyan;
        case FileType.pdf:
          color = GruvboxColors.purple;
        case FileType.hidden:
          color = GruvboxColors.purple;
      }
      spans.add(TextSpan(
        text: '${f.name}  ',
        style: GruvboxText.body(color: color),
      ));
    }

    return [
      RichText(text: TextSpan(children: spans)),
    ];
  }

  static bool exists(String name) => _files.containsKey(name);

  static VirtualFile? getFile(String name) => _files[name];
}
