import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../commands/command_registry.dart';
import '../../commands/builtin_commands.dart';
import '../../widgets/dot_grid_background.dart';
import 'fastfetch_widget.dart';
import 'terminal_controller.dart';
import 'terminal_widget.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  late final CommandRegistry _registry;
  late final TerminalController _controller;
  bool _fastfetchDone = false;

  @override
  void initState() {
    super.initState();
    _registry = _buildRegistry();
    _controller = TerminalController(registry: _registry);
  }

  CommandRegistry _buildRegistry() {
    final reg = CommandRegistry();
    reg.register('ls', LsCommand());
    reg.register('cat', CatCommand());
    reg.register('open', OpenCommand());
    reg.register('pwd', PwdCommand());
    reg.register('whoami', WhoamiCommand());
    reg.register('echo', EchoCommand());
    reg.register('clear', ClearCommand());
    reg.register('git', GitLogCommand());
    reg.register('vim', VimCommand());
    reg.register('man', ManCommand());
    reg.register('sudo', SudoCommand());
    reg.register('cd', CdCommand());
    reg.register('help', HelpCommand());
    reg.register('fastfetch', FastfetchCommand());
    reg.register('exit', ExitCommand());
    return reg;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth > 600 ? 1.5 : 1.0;

    return ChangeNotifierProvider<TerminalController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: GruvboxColors.bg,
        body: Stack(
          children: [
            // Dot grid background
            const DotGridBackground(),
            // Centered terminal
            Center(
              child: Transform.scale(
                scale: scale,
                child: const TerminalWidget(),
              ),
            ),
            // Fastfetch trigger (invisible, fires once)
            if (!_fastfetchDone)
              Positioned.fill(
                child: FastfetchWidget(
                  controller: _controller,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
