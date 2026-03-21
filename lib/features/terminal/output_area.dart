import 'package:flutter/material.dart';
import '../../config/colors.dart';
import 'terminal_controller.dart';

class OutputArea extends StatelessWidget {
  final TerminalController controller;

  const OutputArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Scrollbar(
        controller: controller.scrollController,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(2),
        child: ColoredBox(
          color: GruvboxColors.bg_hard,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: controller.outputLines.length,
            itemBuilder: (context, index) {
              return controller.outputLines[index];
            },
          ),
        ),
      ),
    );
  }
}
