import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../config/colors.dart';
import 'terminal_controller.dart';

class OutputArea extends StatelessWidget {
  final TerminalController controller;

  const OutputArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final scrollController = controller.scrollController;
          final maxScroll = scrollController.position.maxScrollExtent;
          final minScroll = scrollController.position.minScrollExtent;
          final currentOffset = scrollController.offset;
          final delta = event.scrollDelta.dy;

          final newOffset = (currentOffset + delta).clamp(minScroll, maxScroll);
          scrollController.jumpTo(newOffset);
        }
      },
      child: Scrollbar(
        controller: controller.scrollController,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(2),
        child: ColoredBox(
          color: GruvboxColors.bgHard,
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
