import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../config/constants.dart';
import 'fastfetch_widget.dart';
import 'terminal_controller.dart';
import 'output_area.dart';
import 'input_row.dart';

class TerminalWidget extends StatelessWidget {
  const TerminalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final width = (screen.width * TerminalConstants.terminalWidthRatio)
        .clamp(280.0, TerminalConstants.terminalMaxWidth);
    final height = (screen.height * TerminalConstants.terminalHeightRatio)
        .clamp(300.0, TerminalConstants.terminalMaxHeight);

    return Consumer<TerminalController>(
      builder: (context, controller, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: GruvboxColors.bg_hard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GruvboxColors.surface, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                _TitleBar(),
                OutputArea(controller: controller),
                InputRow(controller: controller),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: TerminalConstants.titleBarHeight,
      color: GruvboxColors.overlay,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Traffic lights
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(GruvboxColors.red_dark),
                const SizedBox(width: 6),
                _dot(const Color(0xFFd79921)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF98971a)),
              ],
            ),
          ),
          // Centered title
          Text(
            'visitor@portfolio ~/portfolio',
            style: GruvboxText.body(color: const Color(0xFF7c6f64), size: 10),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
