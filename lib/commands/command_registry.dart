import 'command_handler.dart';

class CommandRegistry {
  final Map<String, CommandHandler> _handlers = {};

  void register(String name, CommandHandler handler) {
    _handlers[name] = handler;
  }

  CommandHandler? resolve(String name) => _handlers[name];

  List<String> get allCommands => (_handlers.keys.toList()..sort());

  List<String> matchPrefix(String prefix) {
    if (prefix.isEmpty) return [];
    return allCommands.where((cmd) => cmd.startsWith(prefix)).toList();
  }
}
